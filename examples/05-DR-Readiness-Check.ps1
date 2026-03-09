<#
.SYNOPSIS
    Performs DR Readiness Check.
.DESCRIPTION
    Chain: Connect-AnyStackServer → Test-AnyStackDisasterRecoveryReadiness → Test-AnyStackHaFailover → Get-AnyStackVsanHealth → Export-AnyStackDRReadinessReport
#>
param(
    [string]$Server = 'vcenter.corp.local',
    [string]$ClusterName = 'Prod-Cluster'
)

$vi = Connect-AnyStackServer -Server $Server -Credential (Get-Credential)

Test-AnyStackDisasterRecoveryReadiness -Server $vi -ClusterName $ClusterName
Test-AnyStackHaFailover -Server $vi -ClusterName $ClusterName
Get-AnyStackVsanHealth -Server $vi -ClusterName $ClusterName
Export-AnyStackDRReadinessReport -Server $vi
 


