BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.NetworkAudit.psd1" -Force -ErrorAction Stop
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
    }
    Context "Repair-AnyStackNetworkConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Repair-AnyStackNetworkConfiguration' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackHostNicStatus" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackHostNicStatus' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackNetworkConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackNetworkConfiguration' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackVmotionNetwork" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVmotionNetwork' | Should -Not -BeNullOrEmpty
        }
    }
}
