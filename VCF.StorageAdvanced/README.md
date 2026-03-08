# VCF.StorageAdvanced

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.0 · MIT License**

NVMe over Fabrics management for vSphere 8.0 U3 environments: interface provisioning, device discovery, queue depth tuning, and connectivity testing.

## Requirements

- PowerShell 7.2+
- VMware.PowerCLI 13.0+
- vSphere 8.0 U3 / VCF 5.1+
- AnyStack.vSphere (connection management)

## Installation

```powershell
# Install the full AnyStack suite
Install-Module -Name AnyStack -Scope CurrentUser

# Or install this module individually
Install-Module -Name VCF.StorageAdvanced -Scope CurrentUser
```

## Cmdlets

### `Add-AnyStackNvmeInterface`
Provisions an NVMe-oF software adapter on a specified ESXi host.

### `Get-AnyStackNvmeDevice`
Returns NVMe devices visible to ESXi hosts with path and namespace detail.

### `Remove-AnyStackNvmeInterface`
Removes an NVMe-oF software adapter from a specified ESXi host.

### `Set-AnyStackNvmeQueueDepth`
Configures the NVMe queue depth on ESXi hosts for performance tuning.

### `Test-AnyStackNvmeConnectivity`
Validates NVMe-oF fabric connectivity from ESXi hosts to specified targets.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.StorageAdvanced
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
