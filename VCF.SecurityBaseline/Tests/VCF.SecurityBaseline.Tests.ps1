BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.SecurityBaseline.psd1" -Force
}

Describe "VCF.SecurityBaseline Suite" {
    Context "Get-AnyStackEsxiLockdownMode" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.SecurityBaseline"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.SecurityBaseline"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.SecurityBaseline"
            $result = Get-AnyStackEsxiLockdownMode -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackAdIntegration" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.SecurityBaseline"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.SecurityBaseline"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.SecurityBaseline"
            $result = Test-AnyStackAdIntegration -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackHostSyslog" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.SecurityBaseline"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.SecurityBaseline"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.SecurityBaseline"
            $result = Test-AnyStackHostSyslog -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackSecurityBaseline" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.SecurityBaseline"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.SecurityBaseline"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.SecurityBaseline"
            $result = Test-AnyStackSecurityBaseline -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
