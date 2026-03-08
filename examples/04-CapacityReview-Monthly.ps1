<#
.SYNOPSIS
    Performs Monthly Capacity Review.
.DESCRIPTION
    Chain: Connect-AnyStackServer â†’ Export-AnyStackCapacityForecast â†’ Get-AnyStackZombieVm â†’ Get-AnyStackDatastoreGrowthRate â†’ Get-AnyStackOrphanedVmdk â†’ Set-AnyStackRightSizeRecommendation -WhatIf
#>
param(
    [string]$Server = 'vcenter.corp.local',
    [string]$ClusterName = 'Prod-Cluster',
    [string]$DatastoreName = 'vsanDatastore'
)

$vi = Connect-AnyStackServer -Server $Server -Credential (Get-Credential)

Export-AnyStackCapacityForecast -Server $vi -ClusterName $ClusterName
Get-AnyStackZombieVm -Server $vi -ClusterName $ClusterName
Get-AnyStackDatastoreGrowthRate -Server $vi -DatastoreName $DatastoreName
Get-AnyStackOrphanedVmdk -Server $vi -DatastoreName $DatastoreName
Set-AnyStackRightSizeRecommendation -Server $vi -VmName 'DB-01' -WhatIf


 

