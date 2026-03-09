# AnyStack.Reporting

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.2 · MIT License**

Generate HTML infrastructure reports covering cluster health, capacity utilization, and environment state. Useful for weekly ops reviews or customer-facing reporting.

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

### `Export-AnyStackHtmlReport`
Renders a full-environment HTML report covering compute, storage, and network health across all clusters.

### `Invoke-AnyStackReport`
Runs a targeted report against a specified scope (cluster, datacenter, or full vCenter) and returns structured output.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module AnyStack.Reporting
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 



