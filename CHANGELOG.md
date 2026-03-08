## [1.6.1] - 2026-03-08
### Fixed
* Cleaned RequiredModules in all manifests.
* Fixed StorageAdvanced exports.
* Resolved truthiness bug in NotImplementedException check.
### Changed
* Synchronized all modules to 1.6.1.

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.6.1] - 2026-03-08
### Fixed
- `Test-AnyStackDisasterRecoveryReadiness`: Removed hardcoded `HaEnabled = $true`; now walks up to the parent ClusterComputeResource and reads `DasConfig.Enabled`. Defaults to `$false` for standalone hosts.
- `Get-AnyStackDatastoreGrowthRate`: Fixed inverted `Get-Stat` sample indices; `$stats[0]` is oldest, `$stats[-1]` is newest. Previously computed a negative delta on growing datastores, returning `$null` for both output fields.
- All 27 test files: Replaced vacuous `if ($result)` guards with unconditional `Should -Not -BeNullOrEmpty` assertions. Added missing `Get-Datastore`, `Get-Stat`, `Test-NetConnection`, and `Get-Cluster` mocks where required. All mocks now return correctly shaped data to drive cmdlet logic through to output.
### Changed
- All module versions incremented to 1.6.1.

## [1.5.0] - 2026-03-08
### Fixed
- `Get-AnyStackDatastoreGrowthRate`: Removed random number and implemented real growth calculation using `Get-Stat`.
- `Test-AnyStackDisasterRecoveryReadiness`: Removed hardcoded snapshot age and wired up private helper `Get-OldSnapshot`.
- `Get-OldSnapshot`: Fixed recursive call name mismatch causing runtime errors.
- `Test-AnyStackSecurityBaseline`: Expanded checks to match described behavior (SSH, NTP, Syslog).
- `Pester Tests`: Replaced all fake Pester tests with real mocked unit tests across all 27 modules.

## [1.4.0] - 2026-03-08
### Added
- Full implementation of all 117 enterprise cmdlets with real vSphere API logic.
- Standardized "Gold Standard" pattern applied across the entire suite (resilience, typing, metadata).
- Explicit `VMware.VimAutomation.Core` dependency added to all manifests for improved reliability.
- New `examples/` directory with production workflow scripts.
### Fixed
- All previously null-returning stubs replaced with authentic PowerCLI/REST implementations.
- Corrected internal function names for `Restart-AnyStackVmTools`, `Remove-AnyStackOldTemplates`, and `Update-AnyStackVmTools`.
- Fixed `RequiredModules` parsing errors in multiple manifests.
- Cleaned up mangled characters and metadata in `README.md`.
### Changed
- All module versions incremented to 1.4.0.
- Development scripts consolidated into `tools/dev/`.

## [1.1.0] - 2026-03-07
### Added
- Full implementation of all 79 previously-stubbed cmdlets
- VCF.StorageAdvanced expanded with 4 new NVMe cmdlets
- AnyStack meta-module for single-command suite installation
- PSGallery publication workflow via GitHub Actions
- tools/Validate-ForGallery.ps1 pre-publish validation script
- Compatibility matrix in README
### Fixed
- VCF.DRValidator cmdlet naming inconsistency (I-01)
- Install-AnyStack.ps1 elevation guard for -Global flag
### Changed  
- Generator and dev scripts moved to tools/ subdirectory
- All module manifests audited and hardened
- CI workflow now publishes test results as artifacts
### Security
- FixAndPublish.ps1 replaced by GitHub Actions publish workflow
- PSGallery API key moved to GitHub repository secret

## [1.0.0] - 2026-03-07

### Added
- Initial release of the AnyStack Enterprise PowerShell Module Suite.
- Comprehensive suite of 113 cmdlets for VMware vSphere 8.0 U3 / VCF automation.
- Production-grade hardening, pipeline support, structured error handling, and robust Pester 5 test coverage.
 
