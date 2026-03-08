BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\AnyStack.vSphere.psd1" -Force
}

Describe "AnyStack.vSphere Suite" {
    Context "Connect-AnyStackServer" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.vSphere"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.vSphere"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.vSphere"
            Mock Connect-VIServer { return [PSCustomObject]@{Name="MockVC"; SessionId="sess-1"; Version="8.0"; Build="12345"} } -ModuleName "AnyStack.vSphere"
            $result = Connect-AnyStackServer -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Disconnect-AnyStackServer" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.vSphere"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.vSphere"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.vSphere"
            Mock Connect-VIServer { return [PSCustomObject]@{Name="MockVC"; SessionId="sess-1"; Version="8.0"; Build="12345"} } -ModuleName "AnyStack.vSphere"
            $result = Disconnect-AnyStackServer -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackLicenseUsage" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.vSphere"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.vSphere"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.vSphere"
            Mock Connect-VIServer { return [PSCustomObject]@{Name="MockVC"; SessionId="sess-1"; Version="8.0"; Build="12345"} } -ModuleName "AnyStack.vSphere"
            $result = Get-AnyStackLicenseUsage -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVcenterServices" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.vSphere"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.vSphere"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.vSphere"
            Mock Connect-VIServer { return [PSCustomObject]@{Name="MockVC"; SessionId="sess-1"; Version="8.0"; Build="12345"} } -ModuleName "AnyStack.vSphere"
            $result = Get-AnyStackVcenterServices -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Invoke-AnyStackHealthCheck" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.vSphere"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.vSphere"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.vSphere"
            Mock Connect-VIServer { return [PSCustomObject]@{Name="MockVC"; SessionId="sess-1"; Version="8.0"; Build="12345"} } -ModuleName "AnyStack.vSphere"
            $result = Invoke-AnyStackHealthCheck -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Write-AnyStackLog" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.vSphere"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.vSphere"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.vSphere"
            Mock Connect-VIServer { return [PSCustomObject]@{Name="MockVC"; SessionId="sess-1"; Version="8.0"; Build="12345"} } -ModuleName "AnyStack.vSphere"
            $result = Write-AnyStackLog -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 
