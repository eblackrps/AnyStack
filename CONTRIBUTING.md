# Contributing to AnyStack Enterprise

Thanks for your interest in contributing to AnyStack! We want to make this the best automation suite for vSphere admins everywhere.

## Code Standards
To maintain enterprise quality, all contributions must follow these rules:

### 1. Function Naming
Use the standard PowerShell `Verb-Noun` format. All nouns should start with the `AnyStack` prefix (e.g., `Get-AnyStackHostHealth`).

### 2. Idempotency & Safety
Any function that modifies the environment (`Set-*`, `New-*`, `Remove-*`, `Start-*`, `Invoke-*`) **MUST** support `-WhatIf` and `-Confirm`.
*   Include `[CmdletBinding(SupportsShouldProcess=$true)]`.
*   Wrap destructive actions in `if ($PSCmdlet.ShouldProcess($Target, $Action)) { ... }`.

### 3. Error Handling
*   Set `$ErrorActionPreference = 'Stop'` within the `process` block.
*   Use `try/catch` blocks for all API calls to provide meaningful error messages.

### 4. Documentation
All public functions must include Comment-Based Help with at least:
*   `.SYNOPSIS`
*   `.DESCRIPTION`
*   At least one `.EXAMPLE`
*   Properly documented `.PARAMETER` descriptions.

## Pull Request Process
1.  Fork the repo and create your branch from `main`.
2.  If you've added code that should be tested, add tests!
3.  Ensure the test suite passes (`./test-syntax.ps1` and `./build.ps1`).
4.  Update the `CHANGELOG.md` with a brief summary of your changes.
