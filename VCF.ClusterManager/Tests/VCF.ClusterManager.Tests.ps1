BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.ClusterManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ClusterManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ClusterManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackClusterReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostFirmware'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostSensors'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['New-AnyStackHostProfile'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackDrsRule'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackHostPowerPolicy'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackVclsRetreatMode'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackVmAffinityRule'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackHaFailover'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackHostNtp'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackProactiveHa'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackClusterReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackClusterReport' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackHostFirmware" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostFirmware' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackHostSensors" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostSensors' | Should -Not -BeNullOrEmpty
        }
    }
    Context "New-AnyStackHostProfile" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackHostProfile' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackDrsRule" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackDrsRule' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackHostPowerPolicy" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackHostPowerPolicy' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackVclsRetreatMode" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVclsRetreatMode' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackVmAffinityRule" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVmAffinityRule' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackHaFailover" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHaFailover' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackHostNtp" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHostNtp' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackProactiveHa" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackProactiveHa' | Should -Not -BeNullOrEmpty
        }
    }
}
