# VCF.NetworkAudit

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.7.1 · MIT License**

Network configuration auditing: MAC address conflicts, NIC status, vMotion network validation, and DVS configuration checks.

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
Install-Module -Name VCF.NetworkAudit -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackMacAddressConflict`
Scans the environment for duplicate MAC addresses across virtual NICs.

### `Repair-AnyStackNetworkConfiguration`
Remediates identified network configuration issues. Supports -WhatIf.

### `Test-AnyStackHostNicStatus`
Reports physical NIC link state and speed for all hosts in scope.

### `Test-AnyStackNetworkConfiguration`
Runs a broad network configuration audit across DVS port groups and host networking.

### `Test-AnyStackVmotionNetwork`
Validates vMotion network configuration including kernel port binding and MTU.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.NetworkAudit
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 











