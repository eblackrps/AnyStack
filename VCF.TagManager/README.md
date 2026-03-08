# VCF.TagManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.1 · MIT License**

Tag and category management at scale. Identify untagged VMs, clean up stale tags, and sync tag categories across the environment.

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
Install-Module -Name VCF.TagManager -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackUntaggedVm`
Returns VMs missing one or more required tag categories.

### `Remove-AnyStackStaleTag`
Removes tag assignments for tags that no longer exist in the tag category.

### `Set-AnyStackResourceTag`
Applies a specified tag to one or more vSphere objects.

### `Sync-AnyStackTagCategory`
Reconciles tag category definitions against a desired-state configuration.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.TagManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
