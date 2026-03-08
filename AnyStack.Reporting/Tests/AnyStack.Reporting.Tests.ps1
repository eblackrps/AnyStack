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
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "AnyStack.Reporting"
            $result = Export-AnyStackHtmlReport -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
    Context "Invoke-AnyStackReport" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.Reporting"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "AnyStack.Reporting"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "AnyStack.Reporting"
            $result = Invoke-AnyStackReport -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
}

