BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.PerformanceProfiler.psd1" -Force -ErrorAction Stop
}

Describe "VCF.PerformanceProfiler Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.PerformanceProfiler'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackPerformanceBaseline'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostCpuCoStop'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVmStorageLatency'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackNetworkDroppedPackets'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackPerformanceBaseline" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackPerformanceBaseline' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackHostCpuCoStop" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostCpuCoStop' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVmStorageLatency" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmStorageLatency' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackNetworkDroppedPackets" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackNetworkDroppedPackets' | Should -Not -BeNullOrEmpty
        }
    }
}
