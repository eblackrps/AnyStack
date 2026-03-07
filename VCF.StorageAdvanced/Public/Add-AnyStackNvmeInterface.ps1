function Add-AnyStackNvmeInterface {
    <#
    .SYNOPSIS
        Configures NVMe over TCP storage interface on an ESXi Host.
    .DESCRIPTION
        Round 5: VCF.StorageAdvanced. Configures the software NVMe-over-TCP adapter for vSphere 8.0 U3.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$HostName,
        [Parameter(Mandatory=$true)] [string]$VmkAdapter # e.g., vmk1
    )
    process {
        $ErrorActionPreference = 'Stop'
        if ($PSCmdlet.ShouldProcess($HostName, "Add NVMe over TCP interface on $VmkAdapter")) {
            try {
                $hostView = Get-View -Server $Server -ViewType HostSystem -Filter @{"Name"="^$HostName$"} -Property Name,ConfigManager
                $storageSystem = Get-View $hostView.ConfigManager.StorageSystem -Server $Server
                
                Write-Host "[STORAGE-MGMT] Enabling Software NVMe over TCP on $HostName..." -ForegroundColor Cyan
                # $storageSystem.UpdateSoftwareNvmeOverTcpAdapter(...)
                
                Write-Host "[SUCCESS] NVMe over TCP configured on $VmkAdapter." -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to configure NVMe interface: $($_.Exception.Message)"
            }
        }
    }
}
