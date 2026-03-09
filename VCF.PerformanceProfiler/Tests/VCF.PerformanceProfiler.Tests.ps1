BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
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
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackPerformanceBaseline' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackPerformanceBaseline -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackHostCpuCoStop" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostCpuCoStop' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackHostCpuCoStop -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackVmStorageLatency" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmStorageLatency' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackVmStorageLatency -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackNetworkDroppedPackets" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackNetworkDroppedPackets' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackNetworkDroppedPackets -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
