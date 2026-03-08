$path = "README.md"
$content = [System.IO.File]::ReadAllText($path)
$content = $content -replace "ðŸ“¸", ([char]0xD83D + [char]0xDCF8)
$content = $content -replace "ðŸš€", ([char]0xD83D + [char]0xDE80)
$content = $content -replace "âš™ï¸", ([char]0x2699 + [char]0xFE0F)
$content = $content -replace "âš–ï¸", ([char]0x2696 + [char]0xFE0F)
$content = $content -replace "ðŸ“¦", ([char]0xD83D + [char]0xDCE6)
$content = $content -replace "ðŸ› ", ([char]0xD83D + [char]0xDEE0)
$content = $content -replace "ðŸ“‚", ([char]0xD83D + [char]0xDCC1)
$content = $content -replace "ðŸ§ª", ([char]0xD83E + [char]0xDDEA)
$content = $content -replace "ðŸ¤", ([char]0xD83E + [char]0xDD1D)
$content = $content -replace "ðŸ“„", ([char]0xD83D + [char]0xDCC4)
$content = $content -replace "\*\*Version:\*\* 1\.[0-9\.]+", "**Version:** 1.4.0"
[System.IO.File]::WriteAllText($path, $content)
Write-Host "README.md fixed."
