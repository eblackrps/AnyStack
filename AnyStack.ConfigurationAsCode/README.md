# AnyStack.ConfigurationAsCode

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.5 · MIT License**

Export and sync vCenter configurations declaratively. Treat your vCenter config as code — export current state, version it, and sync it back after rebuilds or drift.

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
Install-Module -Name AnyStack.vSphere -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackConfiguration`
Exports current vCenter configuration to a structured JSON file including roles, permissions, folders, tags, and resource pools.

### `Sync-AnyStackConfiguration`
Applies a previously exported configuration back to a vCenter, detecting and reconciling drift from the desired state.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module AnyStack.ConfigurationAsCode
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 







