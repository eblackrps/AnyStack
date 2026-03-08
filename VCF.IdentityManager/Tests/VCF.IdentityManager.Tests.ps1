BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.IdentityManager.psd1" -Force
}

Describe "VCF.IdentityManager Suite" {
    Context "Export-AnyStackAccessMatrix" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.IdentityManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.IdentityManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.IdentityManager"
            $result = Export-AnyStackAccessMatrix -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackGlobalPermission" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.IdentityManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.IdentityManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.IdentityManager"
            $result = Get-AnyStackGlobalPermission -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "New-AnyStackCustomRole" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.IdentityManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.IdentityManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.IdentityManager"
            $result = New-AnyStackCustomRole -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackSsoConfiguration" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.IdentityManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.IdentityManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.IdentityManager"
            $result = Test-AnyStackSsoConfiguration -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
