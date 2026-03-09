BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.NetworkManager.psd1" -Force
}

Describe "VCF.NetworkManager Suite" {
    Context "Get-AnyStackDistributedPortgroup" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.NetworkManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.NetworkManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.NetworkManager"
            $result = Get-AnyStackDistributedPortgroup -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "New-AnyStackVlan" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.NetworkManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.NetworkManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.NetworkManager"
            $result = New-AnyStackVlan -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackVlanTag" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.NetworkManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.NetworkManager"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "VCF.NetworkManager"
            $result = Set-AnyStackVlanTag -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 


