BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.ContentManager.psd1" -Force
}

Describe "VCF.ContentManager Suite" {
    Context "Get-AnyStackLibraryItem" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ContentManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ContentManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.ContentManager"
            $result = Get-AnyStackLibraryItem -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "New-AnyStackVmTemplate" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ContentManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ContentManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.ContentManager"
            $result = New-AnyStackVmTemplate -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Remove-AnyStackOrphanedIso" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ContentManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ContentManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.ContentManager"
            $result = Remove-AnyStackOrphanedIso -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Sync-AnyStackContentLibrary" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.ContentManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.ContentManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.ContentManager"
            $result = Sync-AnyStackContentLibrary -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 


