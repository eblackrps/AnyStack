# VCF.ContentManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · MIT License**

Content Library and template management. Sync libraries, clean up orphaned ISOs, and manage VM templates at scale.

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
Install-Module -Name VCF.ContentManager -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackLibraryItem`
Returns items in a specified Content Library with metadata and sync state.

### `New-AnyStackVmTemplate`
Creates a new VM template from an existing VM.

### `Remove-AnyStackOrphanedIso`
Identifies and removes ISO files in Content Libraries that are not referenced by any VM or template.

### `Sync-AnyStackContentLibrary`
Forces a sync of a subscribed Content Library against its publication source.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.ContentManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/VCF.ContentManager)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 
