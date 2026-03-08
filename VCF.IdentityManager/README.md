# VCF.IdentityManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.1 · MIT License**

Role-based access control auditing, global permissions management, and SSO configuration validation.

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
Install-Module -Name VCF.IdentityManager -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackAccessMatrix`
Exports the full RBAC permission matrix across the vCenter inventory to CSV.

### `Get-AnyStackGlobalPermission`
Returns all global permissions assigned in vCenter.

### `New-AnyStackCustomRole`
Creates a custom vCenter role with a specified privilege set.

### `Test-AnyStackSsoConfiguration`
Validates SSO identity source configuration and tests authentication connectivity.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.IdentityManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
