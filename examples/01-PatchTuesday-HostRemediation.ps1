<#
.SYNOPSIS
    Automates Patch Tuesday host remediation.
.DESCRIPTION
    Chain: Connect-AnyStackServer → Test-AnyStackCompliance → Test-AnyStackCertificates → Clear-AnyStackOrphanedSnapshots -WhatIf → Start-AnyStackHostEvacuation -WhatIf → Start-AnyStackHostRemediation -WhatIf → Stop-AnyStackHostEvacuation -WhatIf → Export-AnyStackClusterReport
#>
param(
    [string]$Server = 'vcenter.corp.local',
    [string]$ClusterName = 'Prod-Cluster',
    [string]$HostName = 'esxi-01.corp.local'
)

$vi = Connect-AnyStackServer -Server $Server -Credential (Get-Credential)

Test-AnyStackCompliance -Server $vi -ClusterName $ClusterName
Test-AnyStackCertificates -Server $vi -ClusterName $ClusterName
Clear-AnyStackOrphanedSnapshots -Server $vi -ClusterName $ClusterName -WhatIf
Start-AnyStackHostEvacuation -Server $vi -HostName $HostName -WhatIf
Start-AnyStackHostRemediation -Server $vi -HostName $HostName -WhatIf
Stop-AnyStackHostEvacuation -Server $vi -HostName $HostName -WhatIf
Export-AnyStackClusterReport -Server $vi -ClusterName $ClusterName
