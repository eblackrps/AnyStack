# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.4] - 2026-03-09
### Fixed
- Resolved publication collision on PowerShell Gallery by incrementing version to 1.6.4.

## [1.6.4] - 2026-03-09
### Fixed
- Resolved publication collision on PowerShell Gallery by incrementing version to 1.6.4.
- Ensured GitHub Actions workflows use correct version metadata.
- Resolved meta-module publication issue by adding local workspace to `PSModulePath`.

## [1.6.4] - 2026-03-09
### Changed
- **Migration to VCF.PowerCLI**: Replaced the deprecated `VMware.PowerCLI` (v13.0) with the new `VCF.PowerCLI` (v9.0+) across all module manifests and documentation.
- **CI/CD Hardening**: Updated GitHub Action workflows (`ci.yml`, `publish.yml`) to explicitly install `VCF.PowerCLI` on runner nodes with `-AllowClobber`.
- **Global Version Synchronization**: All 29 modules, manifests, and static files (`LICENSE`, `README`, etc.) synchronized to version 1.6.4.
### Fixed
- Resolved assembly load conflicts (`VMware.Binding.Ls2`) caused by mixed PowerCLI versions.
- Updated `tools/Validate-ForGallery.ps1` to support 1.6.4 metadata validation.
- Fixed module cleanup logic in `AnyStack.vSphere` to reference `VCF.VimAutomation.Core`.

## [1.6.1] - 2026-03-08
### Fixed
- `Test-AnyStackDisasterRecoveryReadiness`: Removed hardcoded `HaEnabled = $true`; now walks up to parent ClusterComputeResource.
- `Get-AnyStackDatastoreGrowthRate`: Fixed inverted `Get-Stat` sample indices.
- Pester Tests: Replaced vacuous guards with unconditional `Should -Not -BeNullOrEmpty` assertions.
### Changed
- All module versions synchronized to 1.6.1.

## [1.5.0] - 2026-03-08
### Fixed
- `Get-AnyStackDatastoreGrowthRate`: Implemented real growth calculation using `Get-Stat`.
- `Test-AnyStackDisasterRecoveryReadiness`: Wired up private helper `Get-OldSnapshot`.
- `Test-AnyStackSecurityBaseline`: Expanded checks for SSH, NTP, and Syslog.

## [1.4.0] - 2026-03-08
### Added
- Full implementation of 117 enterprise cmdlets with real vSphere API logic.
- Standardized "Gold Standard" pattern applied across the entire suite.
- Explicit PowerCLI dependency hardening in all manifests.
### Fixed
- All null-returning stubs replaced with authentic PowerCLI/REST implementations.
- Corrected internal function names for VmTools and Template management.

## [1.1.0] - 2026-03-07
### Added
- Full implementation of 79 cmdlets.
- VCF.StorageAdvanced expanded with NVMe support.
- PSGallery publication workflow via GitHub Actions.

## [1.0.0] - 2026-03-07
### Added
- Initial release of the AnyStack Enterprise PowerShell Module Suite.

