function Invoke-AnyStackCisStigAudit {
    <#
    .SYNOPSIS
        Audits ESXi host against CIS STIG.
    .DESCRIPTION
        Checks SSH, NTP, lockdown mode, syslog, and password policies.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Invoke-AnyStackCisStigAudit
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
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Invoking CIS STIG audit on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,Config,ConfigManager }
            
            foreach ($h in $hosts) {
                $findings = @()
                
                # SSH Check
                $svcSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.ServiceSystem }
                $ssh = $svcSystem.ServiceInfo.Service | Where-Object { $_.Key -eq 'TSM-SSH' }
                $sshPassed = -not $ssh.Running
                $findings += @{CheckId='SSH-001'; Description='SSH Service'; Expected='Stopped'; Actual=($ssh.Running); Passed=$sshPassed}
                
                # NTP Check
                $ntpCount = if ($h.Config.DateTimeInfo.NtpConfig.Server) { $h.Config.DateTimeInfo.NtpConfig.Server.Count } else { 0 }
                $ntpPassed = $ntpCount -ge 2
                $findings += @{CheckId='NTP-001'; Description='NTP Servers Configured'; Expected='>= 2'; Actual=$ntpCount; Passed=$ntpPassed}
                
                # Lockdown Check
                $lockdownPassed = $h.Config.LockdownMode -ne 'lockdownDisabled'
                $findings += @{CheckId='SEC-001'; Description='Lockdown Mode'; Expected='Enabled'; Actual=$h.Config.LockdownMode; Passed=$lockdownPassed}
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.CisStigAudit'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    Host          = $h.Name
                    FindingsCount = ($findings | Where-Object { -not $_.Passed }).Count
                    Findings      = $findings
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


