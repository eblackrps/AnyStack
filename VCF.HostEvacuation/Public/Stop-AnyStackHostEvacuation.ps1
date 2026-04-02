function Stop-AnyStackHostEvacuation {
    <#
    .SYNOPSIS
        Stops host evacuation (exits Maintenance Mode).
    .DESCRIPTION
        Exits maintenance mode.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER TimeoutSeconds
        Wait timeout.
    .EXAMPLE
        PS> Stop-AnyStackHostEvacuation -HostName 'esx01'
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
        [Parameter(Mandatory=$false)]
        [int]$TimeoutSeconds = 600
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Exit Maintenance Mode")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exiting maintenance mode on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                
                $taskRef = Invoke-AnyStackWithRetry -ScriptBlock { if ($h) { $h.ExitMaintenanceMode_Task(15) } else { $null } }
                if ($taskRef) {
                    $task = Get-Task -Id $taskRef.Value -Server $vi
                    $task | Wait-Task -TimeoutSeconds $TimeoutSeconds | Out-Null
                }
                
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.HostEvacuationStop'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    Host            = $HostName
                    PreviousState   = 'Maintenance'
                    MaintenanceMode = $false
                    Success         = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
