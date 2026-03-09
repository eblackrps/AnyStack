# VCF.StorageAudit

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.2 · MIT License**

Comprehensive storage auditing: IOPS and latency profiling, orphaned VMDK detection, vSAN health, datastore multipathing, and capacity checks.

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
Install-Module -Name VCF.StorageAudit -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackDatastoreIops`
Returns current IOPS metrics for datastores from vSphere stats.

### `Get-AnyStackDatastoreLatency`
Returns read/write latency for datastores.

### `Get-AnyStackOrphanedVmdk`
Scans datastores for VMDK files not associated with any registered VM.

### `Get-AnyStackVmDiskLatency`
Reports per-VM virtual disk latency metrics.

### `Get-AnyStackVsanHealth`
Returns vSAN cluster health summary including disk groups, objects, and resync state.

### `Invoke-AnyStackDatastoreUnmount`
Unmounts a datastore from specified hosts after validating no active VMs are using it.

### `Test-AnyStackDatastorePathMultipathing`
Validates that all datastores have the expected number of active paths and flags single-path conditions.

### `Test-AnyStackStorageConfiguration`
Runs a broad storage configuration audit covering multipathing, VAAI, and storage policy compliance.

### `Test-AnyStackVsanCapacity`
Checks vSAN datastore capacity and reports slack space against configurable warning and critical thresholds.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.StorageAudit
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 



