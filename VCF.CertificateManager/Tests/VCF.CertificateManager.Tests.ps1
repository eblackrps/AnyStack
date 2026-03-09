BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.CertificateManager.psd1" -Force -ErrorAction Stop
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
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackCertificates -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Update-AnyStackEsxCertificate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackEsxCertificate' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Update-AnyStackEsxCertificate -Server 'MockVC' -CertificatePath 'fake.crt' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Update-AnyStackVcsCertificate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackVcsCertificate' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Update-AnyStackVcsCertificate -Server 'MockVC' -CertificatePath 'fake.crt' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
