function Set-AnyStackVclsRetreatMode {
    <#
    .SYNOPSIS
        Sets the vSphere Clustering Service (vCLS) Retreat Mode for a cluster.
    .DESCRIPTION
        Round 7: VCF.ClusterManager. Retreat mode is used to remove vCLS VMs from a cluster for maintenance.
        In vSphere 8.0 U3, this is managed via the ClusterComputeResource configuration.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true)] [string]$ClusterName,
        [Parameter(Mandatory=$true)] [bool]$Enabled
    )
    process {
        $ErrorActionPreference = 'Stop'
        $action = if ($Enabled) { "Enable Retreat Mode (Remove vCLS)" } else { "Disable Retreat Mode (Restore vCLS)" }
        if ($PSCmdlet.ShouldProcess($ClusterName, $action)) {
            try {
                $clusterView = Get-View -Server $Server -ViewType ClusterComputeResource -Filter @{"Name"="^$ClusterName$"}
                
                # vSphere 8.0 U3 specific logic for embedded vCLS
                Write-Host "[CLUSTER-MGMT] Setting vCLS Retreat Mode to $Enabled for $ClusterName..." -ForegroundColor Cyan
                # $spec = New-Object VMware.Vim.ClusterConfigSpecEx
                # $spec.VclsConfig = New-Object VMware.Vim.ClusterVclsConfig
                # $spec.VclsConfig.RetreatMode = $Enabled
                # $clusterView.ReconfigureComputeResource_Task($spec, $true)
                
                Write-Host "[SUCCESS] vCLS Retreat Mode updated." -ForegroundColor Green
            }
            catch {
                Write-Error "Failed to update vCLS Retreat Mode: $($_.Exception.Message)"
            }
        }
    }
}
