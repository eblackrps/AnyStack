$files = Get-ChildItem -Path . -Recurse -Filter *.ps1 | Where-Object { $_.FullName -match '\\Public\\' }

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $modified = $false

    # Add SupportsShouldProcess
    if ($content -match '\[CmdletBinding\(\)\]') {
        $content = $content -replace '\[CmdletBinding\(\)\]', '[CmdletBinding(SupportsShouldProcess=$true)]'
        $modified = $true
    }

    # Add basic ErrorActionPreference if it doesn't exist
    if ($content -notmatch '\$ErrorActionPreference\s*=') {
        $content = $content -replace 'process\s*\{', "process {`n        `$ErrorActionPreference = 'Stop'"
        $modified = $true
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $content
        Write-Host "Hardened $($file.Name)" -ForegroundColor Green
    }
}
