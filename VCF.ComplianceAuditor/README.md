# VCF.ComplianceAuditor

**Part of the [AnyStack Enterprise Module Suite](https://github.com/eblackrps/AnyStack) · MIT License**

STIG and CIS benchmark compliance auditing for ESXi hosts. Identify drift, generate audit reports, and remediate non-compliant configuration.

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
Install-Module -Name VCF.ComplianceAuditor -Scope CurrentUser
```

## Cmdlets

### `Export-AnyStackAuditReport`
Generates a full compliance audit report in HTML and CSV format for the specified scope.

### `Get-AnyStackNonCompliantHost`
Returns hosts with one or more failing compliance checks.

### `Invoke-AnyStackCisStigAudit`
Runs a CIS/STIG audit across ESXi hosts checking lockdown mode, SSH, NTP, syslog, and additional hardening controls.

### `Repair-AnyStackComplianceDrift`
Applies remediation for identified compliance drift items. Supports -WhatIf.

## Usage

```powershell
Import-Module AnyStack.vSphere
Connect-AnyStackServer -Server 'vcenter.yourenv.local'

Import-Module VCF.ComplianceAuditor
```

All cmdlets support `-Verbose`, `-ErrorAction`, and `-WhatIf` where applicable.

## Links

- [Full module suite on GitHub](https://github.com/eblackrps/AnyStack)
- [PowerShell Gallery](https://www.powershellgallery.com/packages/VCF.ComplianceAuditor)
- [anystackarchitect.com](https://www.anystackarchitect.com)
 
