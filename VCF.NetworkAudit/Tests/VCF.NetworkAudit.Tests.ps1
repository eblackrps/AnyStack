BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.NetworkAudit.psd1" -Force -ErrorAction Stop
}

Describe "VCF.NetworkAudit Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.NetworkAudit'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackMacAddressConflict'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Repair-AnyStackNetworkConfiguration'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackHostNicStatus'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackNetworkConfiguration'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackVmotionNetwork'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackMacAddressConflict" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackMacAddressConflict' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackMacAddressConflict -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Repair-AnyStackNetworkConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Repair-AnyStackNetworkConfiguration' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Repair-AnyStackNetworkConfiguration -Server 'MockVC' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackHostNicStatus" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHostNicStatus' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackHostNicStatus -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackNetworkConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackNetworkConfiguration' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackNetworkConfiguration -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackVmotionNetwork" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVmotionNetwork' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackVmotionNetwork -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
