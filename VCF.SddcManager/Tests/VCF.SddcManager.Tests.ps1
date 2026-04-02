BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.SddcManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SddcManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SddcManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackWorkloadDomain'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackPasswordRotation'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackSddcHealth'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackWorkloadDomain" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackWorkloadDomain' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackPasswordRotation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackPasswordRotation' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackSddcHealth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackSddcHealth' | Should -Not -BeNullOrEmpty
        }
    }
}
