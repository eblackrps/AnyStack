# VCF.ResourceAudit

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · MIT License**

VM-level resource auditing: memory usage, uptime, migration history, CPU ready, orphaned state, and VMware Tools currency.

## Requirements

- PowerShell 7.2+
- VCF.PowerCLI 9.0+
- vSphere 8.0 U3 / VCF 5.1+
- AnyStack.vSphere (connection management)

## Installation

```powershell
# Install the full AnyStack suite
Install-Module -Name AnyStack -Scope CurrentUser

# Or install this module individually
Install-Module -Name VCF.ResourceAudit -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackHostMemoryUsage`
Returns current memory utilization by host including balloon, swap, and compressed memory.

### `Get-AnyStackOrphanedState`
Identifies VMs registered to a host but missing their backing VMDK files.

### `Get-AnyStackVmMigrationHistory`
Returns vMotion and Storage vMotion history for VMs over a configurable lookback window.

### `Get-AnyStackVmUptime`
Reports continuous uptime for all running VMs.

### `Move-AnyStackVmDatastore`
Storage vMotions a VM to a specified target datastore.

### `Remove-AnyStackOldTemplates`
Removes VM templates older than a specified age threshold. Supports -WhatIf.

### `Restart-AnyStackVmTools`
Restarts VMware Tools on a specified VM.

### `Set-AnyStackVmResourcePool`
Moves a VM to a specified resource pool.

### `Test-AnyStackVmCpuReady`
Reports CPU ready percentage for VMs, flagging those exceeding a configurable threshold.

### `Update-AnyStackVmHardware`
Upgrades VM hardware compatibility version to the current host default.

### `Update-AnyStackVmTools`
Updates VMware Tools on a specified VM.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.ResourceAudit
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 
