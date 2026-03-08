# AnyStack Enterprise Module Suite - Syntax Validation Script v1.5.0
$errors = @()
$files = Get-ChildItem -Path . -Recurse -Include *.ps1, *.psm1
foreach ($file in $files) {
    $parseErrors = $null
    $tokens = $null
    [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)
    if ($parseErrors) {
        foreach ($err in $parseErrors) {
            $errors += [PSCustomObject]@{
                File = $file.FullName
                Line = $err.Extent.StartLineNumber
                Message = $err.Message
            }
        }
    }
}
if ($errors.Count -gt 0) {
    $errors | Format-Table -AutoSize
    exit 1
} else {
    Write-Host 'All files passed syntax check.'
}


 

