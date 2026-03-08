# VCF.LifecycleManager

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.1 · MIT License**

vSphere Lifecycle Manager operations: cluster images, host remediation, hardware compatibility, and compliance checks.

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
Install-Module -Name VCF.LifecycleManager -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackHardwareCompatibility`
Exports a hardware compatibility report for cluster hosts against the current cluster image.

### `Get-AnyStackClusterImage`
Returns the current vLCM cluster image applied to a cluster.

### `Start-AnyStackHostRemediation`
Remediates a host against the cluster image using vSphere Lifecycle Manager.

### `Test-AnyStackCompliance`
Checks host compliance against the applied cluster image and returns non-compliant components.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.LifecycleManager
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
