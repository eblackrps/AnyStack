# VCF.AutomationOrchestrator

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · v1.6.0 · MIT License**

Manage scheduled tasks, snapshot automation, and event webhooks. Keeps automation infrastructure clean and auditable.

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
Install-Module -Name VCF.AutomationOrchestrator -Scope CurrentUser
```

## Cmdlets

### `Get-AnyStackFailedScheduledTask`
Returns scheduled tasks with a failed or error state, with last run time and error detail.

### `New-AnyStackScheduledSnapshot`
Creates a policy-driven scheduled snapshot for a VM or group of VMs.

### `Set-AnyStackEventWebhook`
Configures a vCenter event webhook endpoint for integration with external systems.

### `Sync-AnyStackAutomationScripts`
Validates and re-registers automation scripts against the vCenter task scheduler.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.AutomationOrchestrator
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/profiles/eblack099)
- [anystackarchitect.com](https://www.anystackarchitect.com)
