function Update-AnyStackVmHardware {
    <#
    .SYNOPSIS
        Schedules a VM hardware upgrade to the latest supported version (v21).
    .DESCRIPTION
        Round 8: VCF.ResourceAudit Extension. Sets the VM to upgrade hardware on the next graceful reboot.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string[]]$VMName,
        [Parameter(Mandatory=$false)] [string]$TargetVersion = "vmx-21"
    )
    process {
        $ErrorActionPreference = 'Stop'
        foreach ($name in $VMName) {
            if ($PSCmdlet.ShouldProcess($name, "Schedule Hardware Upgrade to $TargetVersion")) {
                try {
                    $vmView = Get-View -Server $Server -ViewType VirtualMachine -Filter @{"Name"="^$name$"} -Property Name
                    $vmView.UpgradeVM_Task($TargetVersion) | Out-Null
                    Write-Host "[RESOURCE-MGMT] Scheduled hardware upgrade for $name to $TargetVersion." -ForegroundColor Cyan
                }
                catch {
                    Write-Error "Failed to schedule upgrade for $name : $($_.Exception.Message)"
                }
            }
        }
    }
}
