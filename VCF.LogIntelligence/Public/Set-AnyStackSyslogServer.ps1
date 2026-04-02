function Set-AnyStackSyslogServer {
    <#
    .SYNOPSIS
        Sets the syslog server for a host.
    .DESCRIPTION
        Updates Syslog.global.logHost in advanced options.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER SyslogServer
        Syslog server URI (e.g. udp://syslog.local:514).
    .EXAMPLE
        PS> Set-AnyStackSyslogServer -HostName 'esx01' -SyslogServer 'syslog.local'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$HostName,
        [Parameter(Mandatory=$true)]
        [string]$SyslogServer
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Set Syslog Server to $SyslogServer")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Updating syslog on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.AdvancedOption }
                
                $prev = if ($optMgr) { ($optMgr.QueryView() | Where-Object { $_.Key -eq 'Syslog.global.logHost' }).Value } else { $null }
                
                Invoke-AnyStackWithRetry -ScriptBlock {
                    if ($optMgr) { $optMgr.UpdateValues(@([VMware.Vim.OptionValue]@{ Key='Syslog.global.logHost'; Value=$SyslogServer })) }
                }
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.SyslogConfig'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    Host          = $HostName
                    PreviousValue = $prev
                    NewValue      = $SyslogServer
                    Applied       = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
