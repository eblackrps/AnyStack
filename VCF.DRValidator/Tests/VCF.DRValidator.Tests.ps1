BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.DRValidator.psd1" -Force -ErrorAction Stop
}

Describe "VCF.DRValidator Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.DRValidator'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackDRReadinessReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Repair-AnyStackDisasterRecoveryReadiness'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackVmBackup'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackDisasterRecoveryReadiness'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackDRReadinessReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackDRReadinessReport' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Repair-AnyStackDisasterRecoveryReadiness" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Repair-AnyStackDisasterRecoveryReadiness' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Start-AnyStackVmBackup" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackVmBackup' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackDisasterRecoveryReadiness" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackDisasterRecoveryReadiness' | Should -Not -BeNullOrEmpty
        }
    }
}
