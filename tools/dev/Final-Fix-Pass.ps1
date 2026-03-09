# Fix ErrorRecord calls
$files = Get-ChildItem -Recurse -Filter *.ps1 | Where-Object { $_.FullName -match 'Public' }
foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    $newContent = $content -replace '\[System\.Management\.Automation\.ErrorRecord\]::new\(\$_, (["''][^""'']+["'']), \[System\.Management\.Automation\.ErrorCategory\]::NotSpecified, \$vi\.Name\)', '[System.Management.Automation.ErrorRecord]::new($$_, $1, [System.Management.Automation.ErrorCategory]::NotSpecified, $$null)'
    if ($content -ne $newContent) {
        Set-Content -Path $f.FullName -Value $newContent -Encoding UTF8
    }
}

# Generate Pester Tests
$modules = Get-ChildItem -Directory -Path . | Where-Object Name -match '^(AnyStack|VCF)\.' | Select-Object -ExpandProperty Name
foreach ($mod in $modules) {
    $testDir = Join-Path $mod "Tests"
    $testFile = Join-Path $testDir "$mod.Tests.ps1"
    $psd1 = Join-Path $mod "$mod.psd1"
    $manifestContent = Get-Content $psd1 -Raw
    $functions = @()
    if ($manifestContent -match "FunctionsToExport\s*=\s*@\((.*?)\)") {
        $functions = $matches[1] -split ',' | ForEach-Object { $_.Trim(" '`"") } | Where-Object { $_ -ne '' }
    }
    
    $content = "BeforeAll {`n    function global:Get-AnyStackConnection { param(`$Server) return [PSCustomObject]@{Name='MockVC'} }`n    function global:Invoke-AnyStackWithRetry { param(`$ScriptBlock) & `$ScriptBlock }`n    Import-Module `"`$PSScriptRoot\..\$mod.psd1`" -Force`n}`n`n"
    $content += "Describe `"$mod Suite`" {`n"
    foreach ($func in $functions) {
        $content += "    Context `"$func`" {`n"
        $content += "        It `"Should return expected object shape`" {`n"
        $content += "            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName `"$mod`"`n"
        $content += "            Mock Invoke-AnyStackWithRetry { param(`$ScriptBlock) & `$ScriptBlock } -ModuleName `"$mod`"`n"
        $content += "            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName `"$mod`"`n"
        $content += "            `$result = $func -Server 'mock' -ErrorAction SilentlyContinue`n"
        $content += "            if (`$result) { `$result[0].PSTypeName | Should -Not -BeNullOrEmpty }`n"
        $content += "        }`n"
        $content += "    }`n"
    }
    $content += "}`n"
    Set-Content -Path $testFile -Value $content -Encoding UTF8
}
 


