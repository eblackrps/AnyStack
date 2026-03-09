BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\AnyStack.Reporting.psd1" -Force
}

Describe "AnyStack.Reporting Suite" {
    Context "Export-AnyStackHtmlReport" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.Reporting"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.Reporting"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.Reporting"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true} } -ModuleName "AnyStack.Reporting"
            $result = Export-AnyStackHtmlReport -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Invoke-AnyStackReport" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.Reporting"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.Reporting"
            Mock Get-View { return @([PSCustomObject]@{Name='esxi01'; MoRef=[PSCustomObject]@{Value='host-1'}; Parent=[PSCustomObject]@{Value='domain-c1'}; Config=[PSCustomObject]@{LockdownMode='lockdownNormal'; DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('ntp1.corp.local','ntp2.corp.local')}}; Option=@([PSCustomObject]@{Key='Syslog.global.logHost'; Value='syslog.corp.local'})}; ConfigManager=[PSCustomObject]@{ServiceSystem=[PSCustomObject]@{Value='svc-1'}}; Hardware=[PSCustomObject]@{SystemInfo=[PSCustomObject]@{Vendor='Dell'; Model='R750'}}; Summary=[PSCustomObject]@{Hardware=[PSCustomObject]@{NumCpuCores=32; MemorySize=137438953472}}}) } -ModuleName "AnyStack.Reporting"
            Mock Get-Cluster { return [PSCustomObject]@{Name="Cluster01"; DrsEnabled=$true; HaEnabled=$true} } -ModuleName "AnyStack.Reporting"
            $result = Invoke-AnyStackReport -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 

