BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.LifecycleManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.LifecycleManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.LifecycleManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackHardwareCompatibility'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackClusterImage'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackHostRemediation'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackCompliance'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackHardwareCompatibility" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackHardwareCompatibility' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackClusterImage" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackClusterImage' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Start-AnyStackHostRemediation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackHostRemediation' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackCompliance" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackCompliance' | Should -Not -BeNullOrEmpty
        }
    }
}
