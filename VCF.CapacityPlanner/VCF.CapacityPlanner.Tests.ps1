BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.CapacityPlanner.psd1" -Force -ErrorAction Stop
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
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackCapacityForecast -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackDatastoreGrowthRate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackDatastoreGrowthRate' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackDatastoreGrowthRate -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackZombieVm" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackZombieVm' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackZombieVm -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackRightSizeRecommendation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackRightSizeRecommendation' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackRightSizeRecommendation -Server 'MockVC' -VmName 'vm1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
