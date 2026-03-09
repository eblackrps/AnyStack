BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.AlarmManager.psd1" -Force
}

Describe "VCF.AlarmManager Suite" {
    Context "Get-AnyStackActiveAlarm" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.AlarmManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.AlarmManager"
            Mock Get-View { return @([PSCustomObject]@{Name='vm01'; MoRef=[PSCustomObject]@{Value='vm-1'}; OverallStatus='red'; TriggeredAlarmState=@([PSCustomObject]@{Alarm=[PSCustomObject]@{Value='alarm-1'}; AcknowledgedByUser=''; Time=(Get-Date)})}) } -ModuleName "VCF.AlarmManager"
            $result = Get-AnyStackActiveAlarm -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 

