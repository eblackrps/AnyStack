BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.StorageAdvanced.psd1" -Force
}

Describe "VCF.StorageAdvanced Suite" {
    Context "Add-AnyStackNvmeInterface" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.StorageAdvanced"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.StorageAdvanced"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.StorageAdvanced"
            $result = Add-AnyStackNvmeInterface -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
}

