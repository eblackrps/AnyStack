BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\VCF.PerformanceProfiler.psd1" -Force -ErrorAction Stop
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
        BeforeEach {
            Mock Get-AnyStackConnection -ModuleName VCF.PerformanceProfiler {
                [PSCustomObject]@{
                    Name        = 'ResolvedVC'
                    IsConnected = $true
                }
            }

            Mock Get-AnyStackHostView -ModuleName VCF.PerformanceProfiler {
                @(
                    [PSCustomObject]@{ Name = 'esx01' },
                    [PSCustomObject]@{ Name = 'esx02' }
                )
            }

            Mock Set-Content -ModuleName VCF.PerformanceProfiler {}
            Mock Test-Path -ModuleName VCF.PerformanceProfiler { $false }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackPerformanceBaseline' | Should -Not -BeNullOrEmpty
        }

        It "Should write a baseline file during normal execution" {
            $result = Export-AnyStackPerformanceBaseline -Server 'InputVC' -ClusterName 'ClusterA' -OutputPath 'C:\temp\baseline.json' -Confirm:$false

            $result.Server | Should -Be 'ResolvedVC'
            $result.HostsProfiled | Should -Be 2
            $result.MetricsCollected | Should -Be 4
            $result.BaselinePath | Should -Be 'C:\temp\baseline.json'
            Assert-MockCalled Set-Content -ModuleName VCF.PerformanceProfiler -Times 1
            Assert-MockCalled Get-AnyStackHostView -ModuleName VCF.PerformanceProfiler -Times 1 -ParameterFilter { $ClusterName -eq 'ClusterA' }
        }

        It "Should skip the file write when -WhatIf is used" {
            $result = Export-AnyStackPerformanceBaseline -Server 'InputVC' -OutputPath 'C:\temp\baseline.json' -WhatIf

            $result.Server | Should -Be 'ResolvedVC'
            $result.HostsProfiled | Should -Be 2
            Assert-MockCalled Set-Content -ModuleName VCF.PerformanceProfiler -Times 0
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
