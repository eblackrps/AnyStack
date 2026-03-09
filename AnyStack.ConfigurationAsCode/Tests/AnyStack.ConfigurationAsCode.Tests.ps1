BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\AnyStack.ConfigurationAsCode.psd1" -Force
}

Describe "AnyStack.ConfigurationAsCode Suite" {
    Context "Export-AnyStackConfiguration" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.ConfigurationAsCode"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.ConfigurationAsCode"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "AnyStack.ConfigurationAsCode"
            
            # Mock PowerCLI cmdlets that are called inside the function
            Mock Get-Folder { return @([PSCustomObject]@{Name='Folder1'; Type='VM'}) } -ModuleName "AnyStack.ConfigurationAsCode"
            Mock Get-Cluster { return @([PSCustomObject]@{Name='Cluster1'; DrsEnabled=$true; HaEnabled=$true}) } -ModuleName "AnyStack.ConfigurationAsCode"
            
            $tempFile = [System.IO.Path]::GetTempFileName()
            try {
                $result = Export-AnyStackConfiguration -Server 'mock' -OutputPath $tempFile -ErrorAction SilentlyContinue
                $result | Should -Not -BeNullOrEmpty
                $result.PSTypeName | Should -Be 'AnyStack.ConfigurationExport'
            }
            finally {
                if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
            }
        }
    }
    Context "Sync-AnyStackConfiguration" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.ConfigurationAsCode"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.ConfigurationAsCode"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "AnyStack.ConfigurationAsCode"
            
            $tempFile = [System.IO.Path]::GetTempFileName()
            try {
                "{\"Server\":\"MockVC\"}" | Set-Content -Path $tempFile
                $result = Sync-AnyStackConfiguration -Server 'mock' -ConfigFilePath $tempFile -ErrorAction SilentlyContinue
                $result | Should -Not -BeNullOrEmpty
                $result.PSTypeName | Should -Be 'AnyStack.ConfigurationSync'
            }
            finally {
                if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
            }
        }
    }
}
 


