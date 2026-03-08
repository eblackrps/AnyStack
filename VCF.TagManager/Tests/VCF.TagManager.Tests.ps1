BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.TagManager.psd1" -Force
}

Describe "VCF.TagManager Suite" {
    Context "Get-AnyStackUntaggedVm" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.TagManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.TagManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.TagManager"
            Mock Get-Tag { return [PSCustomObject]@{Name="env:prod"; Category=[PSCustomObject]@{Name="env"}} } -ModuleName "VCF.TagManager"
            Mock Get-TagAssignment { return @() } -ModuleName "VCF.TagManager"
            $result = Get-AnyStackUntaggedVm -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Remove-AnyStackStaleTag" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.TagManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.TagManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.TagManager"
            Mock Get-Tag { return [PSCustomObject]@{Name="env:prod"; Category=[PSCustomObject]@{Name="env"}} } -ModuleName "VCF.TagManager"
            Mock Get-TagAssignment { return @() } -ModuleName "VCF.TagManager"
            $result = Remove-AnyStackStaleTag -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackResourceTag" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.TagManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.TagManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.TagManager"
            Mock Get-Tag { return [PSCustomObject]@{Name="env:prod"; Category=[PSCustomObject]@{Name="env"}} } -ModuleName "VCF.TagManager"
            Mock Get-TagAssignment { return @() } -ModuleName "VCF.TagManager"
            $result = Set-AnyStackResourceTag -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Sync-AnyStackTagCategory" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.TagManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.TagManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.TagManager"
            Mock Get-Tag { return [PSCustomObject]@{Name="env:prod"; Category=[PSCustomObject]@{Name="env"}} } -ModuleName "VCF.TagManager"
            Mock Get-TagAssignment { return @() } -ModuleName "VCF.TagManager"
            $result = Sync-AnyStackTagCategory -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 
