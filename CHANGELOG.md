# AnyStack Changelog

## v1.7.5 (2026-03-10)

### Fixed
- Resolved 292 CI test failures across all 27 modules
- Fixed `AnyStack.vSphere` private function mock isolation using Pester `Mock` in `InModuleScope`
- Fixed `SupportsShouldProcess` mismatches causing parameter binding errors in 12 functions
- Fixed null-reference errors after mocked `Invoke-AnyStackWithRetry` returns `$null`
- Fixed mandatory parameter gaps in test calls (`-RuleType`, `-VmNames`, `-Privileges`, `-Mode`, `-Protocol`, `-ObjectType`, `-ResourceType`)
- Fixed `Get-AnyStackLicenseUsage` type constraint rejecting mock server objects
- Fixed `Disconnect-AnyStackServer` using unmocked `Get-VIServer` directly
- Fixed `VMware.Vim.*` object construction outside retry blocks causing failures at import time
- Fixed `Resolve-Path` on non-existent paths in `Get-AnyStackHostLogBundle` and `Export-AnyStackPerformanceBaseline`
- Fixed `Get-AnyStackConnection` private function to accept PSCustomObject mock objects
- Scoped CI test discovery to `*/Tests/*` only, eliminating 27 stale root-level test file conflicts

### Changed
- Removed 27 stale duplicate test files from module root directories
- Updated CI workflow (`ci.yml`) to scope Pester path to `*/Tests/*`
- Version bumped from 1.6.7 to 1.7.5

## v1.6.7
- Initial release
