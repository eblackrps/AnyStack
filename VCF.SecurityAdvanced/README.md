# VCF.SecurityAdvanced

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · MIT License**

Advanced security operations: native key provider management, SSH control, and ESXi lockdown mode enforcement.

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
Install-Module -Name VCF.SecurityAdvanced -Scope CurrentUser
```

## Cmdlets

### `Add-AnyStackNativeKeyProvider`
Configures a Native Key Provider on vCenter for VM encryption and vTPM.

### `Disable-AnyStackHostSsh`
Disables SSH on specified ESXi hosts and sets the service policy to off.

### `Enable-AnyStackHostSsh`
Enables SSH on specified ESXi hosts for break-glass access.

### `Set-AnyStackEsxiLockdownMode`
Sets ESXi lockdown mode (normal or strict) on specified hosts.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.SecurityAdvanced
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/VCF.SecurityAdvanced)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 
