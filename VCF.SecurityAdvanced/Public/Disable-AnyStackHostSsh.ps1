function Disable-AnyStackHostSsh {
    <#
    .SYNOPSIS
        Disables host SSH.
    .DESCRIPTION
        Stops the TSM-SSH service.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .EXAMPLE
        PS> Disable-AnyStackHostSsh -HostName 'esx01'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Disable SSH")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Disabling SSH on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $svcSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.ServiceSystem }
                
                $prev = ($svcSystem.ServiceInfo.Service | Where-Object { $_.Key -eq 'TSM-SSH' }).Running
                Invoke-AnyStackWithRetry -ScriptBlock { $svcSystem.StopService('TSM-SSH') }
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.SshStatus'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    Host          = $HostName
                    ServiceName   = 'TSM-SSH'
                    PreviousState = if ($prev) { 'Running' } else { 'Stopped' }
                    NewState      = 'Stopped'
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
