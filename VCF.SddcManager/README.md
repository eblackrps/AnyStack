# VCF.SddcManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.1 · MIT License**

SDDC Manager integration for VCF environments. Workload Domain management, password rotation, and SDDC health checks.

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
Install-Module -Name VCF.SddcManager -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackWorkloadDomain`
Returns all Workload Domains from SDDC Manager with type, status, and cluster membership.

### `Set-AnyStackPasswordRotation`
Triggers a credential rotation for a specified resource type via SDDC Manager.

### `Test-AnyStackSddcHealth`
Runs an SDDC Manager health check and returns component status.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.SddcManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
