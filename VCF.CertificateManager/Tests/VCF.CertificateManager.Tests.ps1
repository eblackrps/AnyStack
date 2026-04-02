BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.CertificateManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.CertificateManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.CertificateManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackCertificates'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Update-AnyStackEsxCertificate'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Update-AnyStackVcsCertificate'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackCertificates" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackCertificates' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Update-AnyStackEsxCertificate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackEsxCertificate' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Update-AnyStackVcsCertificate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackVcsCertificate' | Should -Not -BeNullOrEmpty
        }
    }
}
