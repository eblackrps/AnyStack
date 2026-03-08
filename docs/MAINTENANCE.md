# AnyStack Maintenance Guide

## Broadcom/VMware Release Cadence
As of 2024, VMware products are under Broadcom ownership. VCF and vSphere releases are less predictable. Monitor:
- https://docs.vmware.com/en/VMware-vSphere/index.html
- https://docs.vmware.com/en/VMware-Cloud-Foundation/index.html

### High-Risk Areas for Regression
After each new vSphere/VCF release, prioritize testing:
- **VAMI REST Endpoints:** (/api/appliance/*) versioned and subject to change.
- **vSAN Health API:** (/api/vsan/v1/*) known to change between major updates.
- **SDDC Manager REST API:** (/v1/*) verify endpoints still valid.
- **VMware HCL API:** verify URL and authentication requirements.

## Quarterly Maintenance Tasks
1. Run `Invoke-Pester -Recurse` â€” ensure no regressions.
2. Run `Invoke-ScriptAnalyzer -Recurse -Severity Error` â€” catch new rule violations.
3. Check `Test-AnyStackCertificates` against latest TLS standards.
4. Rotate `PSGALLERY_API_KEY` GitHub secret annually.

## Adding New Cmdlets
1. Add function to appropriate `.psm1` following the gold standard pattern.
2. Add cmdlet name to `FunctionsToExport` in the `.psd1`.
3. Add Pester tests (Happy Path, `-WhatIf`, Connection/Auth failure).
4. Bump `ModuleVersion` in the `.psd1` and the meta-module reference.
5. Update `CHANGELOG.md` and `README.md`.

## Known Fragile Areas
| Cmdlet | Risk | Reason |
|--------|------|--------|
| `Start-AnyStackVcenterBackup` | HIGH | VAMI API versioned |
| `Update-AnyStackVcsCertificate` | HIGH | VAMI API versioned |
| `Export-AnyStackHardwareCompatibility` | HIGH | HCL API external dependency |
| `Get-AnyStackVsanHealth` | HIGH | vSAN API versioned |
| `Get-AnyStackWorkloadDomain` | HIGH | SDDC Manager REST versioned |

## Versioning Policy
- **Patch (1.4.x):** Bug fixes, no new cmdlets.
- **Minor (1.x.0):** New cmdlets added, no breaking changes.
- **Major (x.0.0):** Breaking changes (renames, dropped version support).

 

