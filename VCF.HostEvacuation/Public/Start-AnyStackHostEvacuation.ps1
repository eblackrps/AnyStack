function Start-AnyStackHostEvacuation {
    <#
    .SYNOPSIS
        Safely automates host evacuations via Maintenance Mode for vSphere clusters.

    .DESCRIPTION
        Initiates DRS-based VM evacuation and vSAN data migration protocols for designated hosts.
        Uses Get-View for direct API execution, ensuring speed and reliability during tight maintenance windows.

    .PARAMETER Server
        VIServer connection object.

    .PARAMETER HostName
        Array of ESXi hostnames to evacuate.

    .PARAMETER VsanMode
        vSAN data evacuation mode: 'ensureObjectAccessibility' (default) or 'evacuateAllData'.

    .PARAMETER TimeoutSeconds
        Maximum time to wait for the maintenance task to complete before throwing an error.

    .EXAMPLE
        Start-AnyStackHostEvacuation -Server $vc -HostName "esx01.anystack.local" -VsanMode "evacuateAllData"
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        $Server,

        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [string[]]$HostName,

        [Parameter(Mandatory=$false)]
        [ValidateSet('ensureObjectAccessibility', 'evacuateAllData', 'noAction')]
        [string]$VsanMode = 'ensureObjectAccessibility',

        [Parameter(Mandatory=$false)]
        [int]$TimeoutSeconds = 3600
    )

    process {
        $ErrorActionPreference = 'Stop'
        foreach ($h in $HostName) {
            Write-Verbose "Evaluating Maintenance Mode for Host: $h"
            
            try {
                $hostView = Get-View -Server $Server -ViewType HostSystem -Filter @{"Name"="^$h$"} -Property Name,Runtime -ErrorAction Stop
                
                if (-not $hostView) {
                    Write-Warning "Host $h not found on server."
                    continue
                }

                if ($hostView.Runtime.InMaintenanceMode) {
                    Write-Verbose "Host $h is already in Maintenance Mode."
                    continue
                }

                if ($PSCmdlet.ShouldProcess($h, "Enter Maintenance Mode (vSAN: $VsanMode)")) {
                    
                    # Construct Maintenance Spec
                    $spec = New-Object VMware.Vim.HostMaintenanceSpec
                    $spec.VsanMode = New-Object VMware.Vim.VsanHostDecommissionMode
                    $spec.VsanMode.ObjectAction = $VsanMode

                    Write-Host "Initiating evacuation for $h..." -ForegroundColor Cyan
                    
                    # API Call: EnterMaintenanceMode_Task(timeout, evacuatePoweredOffVms, spec)
                    $taskRef = $hostView.EnterMaintenanceMode_Task($TimeoutSeconds, $true, $spec)
                    
                    # Return Task object
                    [PSCustomObject]@{
                        Host         = $h
                        Status       = "Evacuation Started"
                        VsanMode     = $VsanMode
                        TaskID       = $taskRef.Value
                        Timestamp    = (Get-Date)
                    }
                }
            }
            catch {
                Write-Error "Failed to initiate evacuation for $h : $($_.Exception.Message)"
            }
        }
    }
}
