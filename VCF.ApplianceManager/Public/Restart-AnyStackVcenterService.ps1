function Restart-AnyStackVcenterService {
    <#
    .SYNOPSIS
        Restarts a vCenter service.
    .DESCRIPTION
        Uses ServiceSystem to restart the specified vCenter service.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ServiceName
        Name of the service to restart (e.g. vpxd).
    .EXAMPLE
        PS> Restart-AnyStackVcenterService -ServiceName vpxd
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
        [string]$ServiceName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($vi.Name, "Restart vCenter Service $ServiceName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Restarting service $ServiceName on $($vi.Name)"
                $svcSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.ServiceSystem }
                Invoke-AnyStackWithRetry -ScriptBlock { $svcSystem.RestartService($ServiceName) }
                
                [PSCustomObject]@{
                    PSTypeName    = 'AnyStack.VcenterServiceRestart'
                    Timestamp     = (Get-Date)
                    Server        = $vi.Name
                    ServiceName   = $ServiceName
                    PreviousState = 'Running'
                    NewState      = 'Running'
                    Success       = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
