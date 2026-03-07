function Stop-AnyStackHostEvacuation {
    <#
    .SYNOPSIS
        Exits Maintenance Mode and handles DRS VM return.
    .DESCRIPTION
        Round 4: VCF.HostEvacuation Extension. Safely exits MM via direct API.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string[]]$HostName
    )
    process {
        $ErrorActionPreference = 'Stop'
        foreach ($h in $HostName) {
            $hostView = Get-View -Server $Server -ViewType HostSystem -Filter @{"Name"="^$h$"} -Property Name,Runtime
            if ($hostView.Runtime.InMaintenanceMode) {
                if ($PSCmdlet.ShouldProcess($h, "Exit Maintenance Mode")) {
                    $task = $hostView.ExitMaintenanceMode_Task(0)
                    Write-Output [PSCustomObject]@{ Host = $h; Status = "Exiting Maintenance Mode"; Task = $task.Value }
                }
            } else {
                Write-Verbose "Host $h is already online."
            }
        }
    }
}
