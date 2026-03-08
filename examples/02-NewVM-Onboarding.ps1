<#
.SYNOPSIS
    Automates New VM Onboarding.
.DESCRIPTION
    Chain: Connect-AnyStackServer â†’ Set-AnyStackResourceTag â†’ Set-AnyStackVmResourcePool â†’ Update-AnyStackVmTools -WhatIf â†’ Update-AnyStackVmHardware -WhatIf â†’ Get-AnyStackVmUptime
#>
param(
    [string]$Server = 'vcenter.corp.local',
    [string]$VmName = 'New-VM-01'
)

$vi = Connect-AnyStackServer -Server $Server -Credential (Get-Credential)

Set-AnyStackResourceTag -Server $vi -ObjectName $VmName -ObjectType VirtualMachine -TagName 'Production' -CategoryName 'Environment'
Set-AnyStackVmResourcePool -Server $vi -VmName $VmName -ResourcePoolName 'HighPriority'
Update-AnyStackVmTools -Server $vi -VmName $VmName -WhatIf
Update-AnyStackVmHardware -Server $vi -VmName $VmName -WhatIf
Get-AnyStackVmUptime -Server $vi -VmName $VmName


 

