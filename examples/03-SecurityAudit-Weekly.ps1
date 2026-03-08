<#
.SYNOPSIS
    Performs Weekly Security Audit.
.DESCRIPTION
    Chain: Connect-AnyStackServer → Invoke-AnyStackCisStigAudit → Test-AnyStackSecurityBaseline → Test-AnyStackCertificates → Get-AnyStackEsxiLockdownMode → Export-AnyStackAuditReport
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
