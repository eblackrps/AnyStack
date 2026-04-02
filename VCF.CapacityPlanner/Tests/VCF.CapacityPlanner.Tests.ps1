BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.CapacityPlanner.psd1" -Force -ErrorAction Stop
}

Describe "VCF.CapacityPlanner Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.CapacityPlanner'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackCapacityForecast'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackDatastoreGrowthRate'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackZombieVm'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackRightSizeRecommendation'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackCapacityForecast" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackCapacityForecast' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackDatastoreGrowthRate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackDatastoreGrowthRate' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackZombieVm" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackZombieVm' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackRightSizeRecommendation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackRightSizeRecommendation' | Should -Not -BeNullOrEmpty
        }
    }
}
