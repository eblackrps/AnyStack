BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.SecurityBaseline.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SecurityBaseline Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SecurityBaseline'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackEsxiLockdownMode'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackAdIntegration'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackHostSyslog'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackSecurityBaseline'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackEsxiLockdownMode" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackEsxiLockdownMode' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackAdIntegration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackAdIntegration' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackHostSyslog" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHostSyslog' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackSecurityBaseline" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackSecurityBaseline' | Should -Not -BeNullOrEmpty
        }
    }
}
