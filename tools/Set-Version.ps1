param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = 'Stop'

# 1. Identify current version from AnyStack meta-module
$manifestPath = Join-Path $PSScriptRoot "..\AnyStack\AnyStack.psd1"
if (-not (Test-Path $manifestPath)) {
    Write-Error "Could not find meta-module manifest at $manifestPath"
}

# Compatibility fix: Use Invoke-Expression for manifest parsing if Import-PowerShellDataFile is missing
$manifest = Invoke-Expression (Get-Content $manifestPath -Raw)
$currentVersion = $manifest.ModuleVersion
Write-Host "Current version identified as: $currentVersion" -ForegroundColor Cyan
Write-Host "Targeting new version: $Version" -ForegroundColor Cyan

if ($currentVersion -eq $Version) {
    Write-Warning "Current version is already $Version. Performing 'touch' and validation anyway."
}

# 2. Search and Replace in one pass
Write-Host "Updating all files to version $Version..." -ForegroundColor Yellow
$files = Get-ChildItem -Path "$PSScriptRoot\.." -Recurse -File | Where-Object { 
    $_.FullName -notmatch '\.git' -and 
    $_.Extension -match '\.(psd1|ps1|psm1|md|txt|yml|yaml|LICENSE)$'
}

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    # Handle both '1.6.x' and 'v1.6.x' patterns
    $newContent = $content -replace [regex]::Escape($currentVersion), $Version
    
    if ($content -ne $newContent) {
        $newContent | Set-Content $file.FullName
        Write-Host "  Updated: $($file.FullName)"
    }
}

# 3. Update the validation script itself (special case for the regex check)
$valScriptPath = Join-Path $PSScriptRoot "Validate-ForGallery.ps1"
$valContent = Get-Content $valScriptPath -Raw
$newValContent = $valContent -replace "ModuleVersion\\s\*=\\s\*'[0-9]+\\.?[0-9]*\\.?[0-9]*'", "ModuleVersion\s*=\s*'$($Version -replace '\.', '\.')'"
if ($valContent -ne $newValContent) {
    $newValContent | Set-Content $valScriptPath
    Write-Host "  Updated validation script regex." -ForegroundColor Green
}

# 4. Run Validation
Write-Host "Running pre-publish validation..." -ForegroundColor Yellow
& "$PSScriptRoot\Validate-ForGallery.ps1"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Validation failed. Please resolve version inconsistencies before proceeding."
    exit 1
}
Write-Host "[OK] Validation passed." -ForegroundColor Green

# 5. Git Operations
Write-Host "Performing Git operations..." -ForegroundColor Yellow
git add .
git commit --amend -m "$Version"

# Handle tag recreation
$tagName = "v$Version"
if (git tag -l $tagName) {
    Write-Host "Deleting existing tag $tagName..." -ForegroundColor Gray
    git tag -d $tagName
    git push origin :refs/tags/$tagName
}

Write-Host "Creating tag $tagName..." -ForegroundColor Cyan
git tag -a $tagName -m "$Version"

Write-Host "Force pushing to GitHub..." -ForegroundColor Cyan
git push origin main --tags --force

Write-Host "Successfully set version to $Version and pushed to GitHub." -ForegroundColor Green
