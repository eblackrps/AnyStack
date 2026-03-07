function New-AnyStackVlan {
    <#
    .SYNOPSIS
        Creates a new Distributed Virtual Portgroup with a specified VLAN ID.
    .DESCRIPTION
        Round 1: VCF.NetworkManager. Creates a DVPortgroup on the target Distributed Switch (VDS).
    .PARAMETER VdsName
        The name of the Distributed Virtual Switch.
    .PARAMETER PortgroupName
        The name for the new Distributed Portgroup.
    .PARAMETER VlanId
        The VLAN ID (0-4094).
    .PARAMETER Server
        The VIServer connection object.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$VdsName,
        [Parameter(Mandatory=$true)] [string]$PortgroupName,
        [Parameter(Mandatory=$true)] [int]$VlanId
    )
    process {
        $ErrorActionPreference = 'Stop'
        if ($PSCmdlet.ShouldProcess("$VdsName", "Create Distributed Portgroup $PortgroupName with VLAN $VlanId")) {
            try {
                $vdsView = Get-View -Server $Server -ViewType DistributedVirtualSwitch -Filter @{"Name"="^$VdsName$"} -ErrorAction Stop
                
                $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                $spec.Name = $PortgroupName
                $spec.Type = "earlyBinding" # Default to static binding
                $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                $spec.DefaultPortConfig.Vlan = New-Object VMware.Vim.VmwareDistributedVirtualSwitchVlanIdSpec
                $spec.DefaultPortConfig.Vlan.VlanId = $VlanId
                $spec.DefaultPortConfig.Vlan.Inherited = $false
                
                $taskRef = $vdsView.AddDVPortgroup_Task($spec)
                Write-Host "[API TASK] Creating Portgroup $PortgroupName. Task: $($taskRef.Value)" -ForegroundColor Cyan
            }
            catch {
                Write-Error "Failed to create VLAN Portgroup: $($_.Exception.Message)"
            }
        }
    }
}
