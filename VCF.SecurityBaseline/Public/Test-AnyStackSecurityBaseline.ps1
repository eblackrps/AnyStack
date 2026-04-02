function Test-AnyStackSecurityBaseline {
    <#
    .SYNOPSIS
        Tests security baseline on host.
    .DESCRIPTION
        Checks various security options.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackSecurityBaseline
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [string]$HostName
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing security baseline on $($vi.Name)"
            $hosts = Get-AnyStackHostView -Server $vi -ClusterName $ClusterName -HostName $HostName -Property @('Name','Config','ConfigManager')
            
            foreach ($h in $hosts) {
                $passed = 0
                $failed = 0
                $findings = @()
                
                $lockdownPassed = $h.Config.LockdownMode -ne 'lockdownDisabled'
                if ($lockdownPassed) { $passed++ } else { $failed++ }
                $findings += [PSCustomObject]@{ CheckName='Lockdown'; Expected='Enabled'; Actual=$h.Config.LockdownMode; Passed=$lockdownPassed }
                
                $svcSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.ServiceSystem }
                $ssh = $svcSystem.ServiceInfo.Service | Where-Object { $_.Key -eq 'TSM-SSH' }
                $sshPassed = -not $ssh.Running
                if ($sshPassed) { $passed++ } else { $failed++ }
                $findings += [PSCustomObject]@{ CheckName='SSH'; Expected='Stopped'; Actual=if($ssh.Running){'Running'}else{'Stopped'}; Passed=$sshPassed }
                
                $ntpCount = if ($h.Config.DateTimeInfo.NtpConfig.Server) { $h.Config.DateTimeInfo.NtpConfig.Server.Count } else { 0 }
                $ntpPassed = $ntpCount -ge 2
                if ($ntpPassed) { $passed++ } else { $failed++ }
                $findings += [PSCustomObject]@{ CheckName='NTP'; Expected='>= 2'; Actual=$ntpCount; Passed=$ntpPassed }
                
                $syslogOpt = $h.Config.Option | Where-Object { $_.Key -eq 'Syslog.global.logHost' }
                $syslogVal = if ($syslogOpt) { $syslogOpt.Value } else { '' }
                $syslogPassed = -not [string]::IsNullOrWhiteSpace($syslogVal)
                if ($syslogPassed) { $passed++ } else { $failed++ }
                $findings += [PSCustomObject]@{ CheckName='Syslog'; Expected='Configured'; Actual=$syslogVal; Passed=$syslogPassed }
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.SecurityBaseline'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $h.Name
                    ChecksPassed = $passed
                    ChecksFailed = $failed
                    Findings     = $findings
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
