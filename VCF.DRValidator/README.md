# VCF.DRValidator

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.8 · MIT License**

DR readiness validation: snapshot age, HA state, and network reachability checks across all VMs. Generates readiness reports and surfaces remediation targets.

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
Install-Module -Name VCF.DRValidator -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackDRReadinessReport`
Generates an HTML DR readiness report for the environment.

### `Repair-AnyStackDisasterRecoveryReadiness`
Attempts automated remediation of identified DR readiness issues. Supports -WhatIf.

### `Start-AnyStackVmBackup`
Initiates an on-demand backup of a specified VM.

### `Test-AnyStackDisasterRecoveryReadiness`
Evaluates each VM for snapshot age, HA cluster membership, and network reachability. Returns a scored readiness object per VM.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.DRValidator
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 










