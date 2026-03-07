function Set-AnyStackVlanTag {
    <#
    .SYNOPSIS
        Updates the VLAN tag for an existing Distributed Virtual Portgroup.
    .DESCRIPTION
        Round 2: VCF.NetworkManager. Dynamically updates the VLAN ID on a Distributed Portgroup using Get-View.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$PortgroupName,
        [Parameter(Mandatory=$true)] [int]$VlanId
    )
    process {
        $ErrorActionPreference = 'Stop'
        if ($PSCmdlet.ShouldProcess("$PortgroupName", "Update VLAN to $VlanId")) {
            try {
                $pgView = Get-View -Server $Server -ViewType DistributedVirtualPortgroup -Filter @{"Name"="^$PortgroupName$"} -ErrorAction Stop
                
                $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                $spec.ConfigVersion = $pgView.Config.ConfigVersion
                $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                $spec.DefaultPortConfig.Vlan = New-Object VMware.Vim.VmwareDistributedVirtualSwitchVlanIdSpec
                $spec.DefaultPortConfig.Vlan.VlanId = $VlanId
                $spec.DefaultPortConfig.Vlan.Inherited = $false

                $taskRef = $pgView.ReconfigureDVPortgroup_Task($spec)
                Write-Host "[API TASK] Updating VLAN for $PortgroupName. Task: $($taskRef.Value)" -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to update VLAN tag: $($_.Exception.Message)"
            }
        }
    }
}
