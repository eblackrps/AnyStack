<#
.SYNOPSIS
    Performs Weekly Security Audit.
.DESCRIPTION
    Chain: Connect-AnyStackServer â†’ Invoke-AnyStackCisStigAudit â†’ Test-AnyStackSecurityBaseline â†’ Test-AnyStackCertificates â†’ Get-AnyStackEsxiLockdownMode â†’ Export-AnyStackAuditReport
#>
param(
    [string]$Server = 'vcenter.corp.local',
    [string]$ClusterName = 'Prod-Cluster'
)

$vi = Connect-AnyStackServer -Server $Server -Credential (Get-Credential)

Invoke-AnyStackCisStigAudit -Server $vi -ClusterName $ClusterName
Test-AnyStackSecurityBaseline -Server $vi -ClusterName $ClusterName
Test-AnyStackCertificates -Server $vi -ClusterName $ClusterName
Get-AnyStackEsxiLockdownMode -Server $vi -ClusterName $ClusterName
Export-AnyStackAuditReport -Server $vi -ClusterName $ClusterName


 

