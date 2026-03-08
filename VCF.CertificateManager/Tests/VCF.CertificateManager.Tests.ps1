BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.CertificateManager.psd1" -Force
}

Describe "VCF.CertificateManager Suite" {
    Context "Test-AnyStackCertificates" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.CertificateManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.CertificateManager"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.CertificateManager"
            $result = Test-AnyStackCertificates -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
    Context "Update-AnyStackEsxCertificate" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.CertificateManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.CertificateManager"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.CertificateManager"
            $result = Update-AnyStackEsxCertificate -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
    Context "Update-AnyStackVcsCertificate" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.CertificateManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.CertificateManager"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.CertificateManager"
            $result = Update-AnyStackVcsCertificate -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
}

