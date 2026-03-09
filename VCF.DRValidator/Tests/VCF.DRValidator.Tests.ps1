BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.DRValidator.psd1" -Force
}

Describe "VCF.DRValidator Suite" {
    Context "Export-AnyStackDRReadinessReport" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.DRValidator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.DRValidator"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.DRValidator"
            Mock Test-NetConnection { return $true } -ModuleName "VCF.DRValidator"
            $result = Export-AnyStackDRReadinessReport -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Repair-AnyStackDisasterRecoveryReadiness" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.DRValidator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.DRValidator"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.DRValidator"
            Mock Test-NetConnection { return $true } -ModuleName "VCF.DRValidator"
            $result = Repair-AnyStackDisasterRecoveryReadiness -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Start-AnyStackVmBackup" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.DRValidator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.DRValidator"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.DRValidator"
            Mock Test-NetConnection { return $true } -ModuleName "VCF.DRValidator"
            $result = Start-AnyStackVmBackup -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackDisasterRecoveryReadiness" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.DRValidator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.DRValidator"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; Snapshot=$null; Guest=[PSCustomObject]@{IpAddress='192.168.1.10'}; Runtime=[PSCustomObject]@{PowerState='poweredOn'; Host=[PSCustomObject]@{Value='host-1'}}; Config=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCPU=2; MemoryMB=4096}; Modified=(Get-Date).AddDays(-30)}; Summary=[PSCustomObject]@{Storage=[PSCustomObject]@{Committed=10GB}}}) } -ModuleName "VCF.DRValidator"
            Mock Test-NetConnection { return $true } -ModuleName "VCF.DRValidator"
            $result = Test-AnyStackDisasterRecoveryReadiness -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 

