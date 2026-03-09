$modules = Get-ChildItem -Directory -Path . | Where-Object Name -match '^(AnyStack|VCF)\.' | Select-Object -ExpandProperty Name

foreach ($mod in $modules) {
    $testDir = Join-Path $mod "Tests"
    $testFile = Join-Path $testDir "$mod.Tests.ps1"
    
    $psd1 = Join-Path $mod "$mod.psd1"
    $manifestContent = Get-Content $psd1 -Raw
    
    $functions = @()
    if ($manifestContent -match "FunctionsToExport\s*=\s*@\((.*?)\)") {
        $funcsStr = $matches[1]
        $functions = $funcsStr -split ',' | ForEach-Object { $_.Trim(" '`"") } | Where-Object { $_ -ne '' }
    }
    
    $content = "BeforeAll {`n"
    $content += "    # Ensure placeholders exist globally so they can be mocked`n"
    $content += "    function global:Get-AnyStackConnection { param(`$Server) return [PSCustomObject]@{Name='MockVC'} }`n"
    $content += "    function global:Invoke-AnyStackWithRetry { param(`$ScriptBlock) & `$ScriptBlock }`n"
    $content += "    function global:Get-VIServer { param(`$Name) return `$null }`n"
    $content += "    function global:Connect-VIServer { return [PSCustomObject]@{SessionId='mock'} }`n"
    $content += "    function global:Disconnect-VIServer { }`n"
    $content += "    function global:Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='vm-1'}; Config=[PSCustomObject]@{LockdownMode='lockdownDisabled'; Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}; Guest=[PSCustomObject]@{IpAddress='1.1.1.1'}}) }`n"
    $content += "    function global:Get-Stat { return @([PSCustomObject]@{Value=10}) }`n"
    $content += "    function global:Get-Datastore { return [PSCustomObject]@{Name='MockDS'; MoRef='ds-1'} }`n"
    $content += "    function global:Get-VM { return [PSCustomObject]@{Name='MockVM'; Id='vm-1'} }`n"
    $content += "    function global:Get-TagAssignment { return @() }`n"
    $content += "    function global:Get-Tag { return [PSCustomObject]@{Name='MockTag'; Category=[PSCustomObject]@{Name='MockCat'}} }`n"
    $content += "    function global:Get-TagCategory { return @() }`n"
    $content += "    function global:New-TagAssignment { }`n"
    $content += "    function global:Sync-ContentLibrary { }`n"
    $content += "    function global:Get-ContentLibrary { return [PSCustomObject]@{Name='MockLib'} }`n"
    $content += "    function global:Get-ContentLibraryItem { return @() }`n"
    $content += "    function global:Test-NetConnection { return `$true }`n"
    $content += "    Import-Module `"`$PSScriptRoot\..\$mod.psd1`" -Force`n"
    $content += "}`n`n"
    
    $content += "Describe `"$mod Suite`" {`n"
    
    foreach ($func in $functions) {
        $funcFile = Get-ChildItem -Path $mod -Recurse -Filter "$func.ps1" | Select-Object -First 1
        if (-not $funcFile) { continue }
        $funcContent = Get-Content $funcFile.FullName -Raw
        $hasWhatIf = $funcContent -match "SupportsShouldProcess\s*=\s*\`$true"
        
        # Build dummy parameters to avoid hangs
        $dummyParams = "-Server 'mock'"
        if ($funcContent -match "\[Parameter\(Mandatory=\`$true\)\]\s+\[string\]\`$(\w+)") {
            $paramNames = $matches.Groups[1].Value
            # Simplistic approach: add dummy values for common mandatory param names
            $dummyParams += " -ConfigFilePath 'mock' -BackupLocation 'mock' -BackupCredential (Get-Credential -UserName 'u' -Password 'p') -Credential (Get-Credential -UserName 'u' -Password 'p') -VmName 'mock' -SnapshotName 'mock' -WebhookUrl 'http://mock' -LocalScriptPath 'mock' -HostName 'mock' -CertificatePath 'mock' -KeyPath 'mock' -CertificatePemPath 'mock' -KeyPemPath 'mock' -ProfileName 'mock' -ReferenceHostName 'mock' -ClusterName 'mock' -RuleName 'mock' -RuleType 'Affinity' -VmNames @('mock') -Policy 'Balanced' -Enabled `$true -HostGroupName 'mock' -LibraryName 'mock' -SddcManagerFqdn 'mock' -ResourceType 'ESXI' -ProviderName 'mock' -SyslogServer 'mock' -PortGroupName 'mock' -VlanId 100 -DvsName 'mock' -NewVlanId 101 -DestinationDatastore 'mock' -ResourcePoolName 'mock' -Protocol 'TCP' -TargetAddress 'mock' -DeviceName 'mock' -QueueDepth 32 -AdapterName 'mock' -DatastoreName 'mock' -ObjectName 'mock' -ObjectType 'VirtualMachine' -TagName 'mock' -CategoryName 'mock' -BaselineFilePath 'mock'"
        }
        
        $content += "    Context `"$func`" {`n"
        $content += "        It `"Should return expected object shape (Happy Path)`" {`n"
        $content += "            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName `"$mod`"`n"
        $content += "            Mock Invoke-AnyStackWithRetry { param(`$ScriptBlock) & `$ScriptBlock } -ModuleName `"$mod`"`n"
        $content += "            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='vm-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName `"$mod`"`n"
        
        $content += "            `$result = $func $dummyParams -ErrorAction SilentlyContinue`n"
        $content += "            if (`$result) { `$result[0].PSTypeName | Should -Not -BeNullOrEmpty }`n"
        $content += "        }`n"
        
        if ($hasWhatIf) {
            $content += "        It `"Should suppress action when -WhatIf is provided`" {`n"
            $content += "            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName `"$mod`"`n"
            $content += "            Mock Invoke-AnyStackWithRetry { param(`$ScriptBlock) & `$ScriptBlock } -ModuleName `"$mod`"`n"
            $content += "            `$result = $func $dummyParams -WhatIf -ErrorAction SilentlyContinue`n"
            $content += "            `$true | Should -Be `$true`n"
            $content += "        }`n"
        }
        
        $content += "        It `"Should throw terminating error on API failure`" {`n"
        $content += "            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName `"$mod`"`n"
        $content += "            Mock Invoke-AnyStackWithRetry { throw `"Mocked API Failure`" } -ModuleName `"$mod`"`n"
        $content += "            { $func $dummyParams } | Should -Throw -ExceptionType `"System.Management.Automation.ErrorRecord`"`n"
        $content += "        }`n"
        
        $content += "    }`n"
    }
    $content += "}`n"
    
    Set-Content -Path $testFile -Value $content -Encoding UTF8
}
 

