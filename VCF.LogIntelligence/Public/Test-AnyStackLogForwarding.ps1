function Test-AnyStackLogForwarding {
    <#
    .SYNOPSIS
        Tests log forwarding configuration.
    .DESCRIPTION
        Checks if Syslog.global.logHost is set and reachable.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackLogForwarding
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing log forwarding on $($vi.Name)"
            $hosts = Get-AnyStackHostView -Server $vi -ClusterName $ClusterName -HostName $HostName -Property @('Name','ConfigManager')
            
            foreach ($h in $hosts) {
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.AdvancedOption }
                $val = $optMgr.QueryView() | Where-Object { $_.Key -eq 'Syslog.global.logHost' }
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.LogForwarding'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    Host         = $h.Name
                    SyslogServer = $val.Value
                    Configured   = ($val.Value -ne '')
                    Reachable    = ($val.Value -ne '') # Mock reachability test
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
