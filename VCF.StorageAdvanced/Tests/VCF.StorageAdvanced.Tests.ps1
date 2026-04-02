BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.StorageAdvanced.psd1" -Force -ErrorAction Stop
}

Describe "VCF.StorageAdvanced Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.StorageAdvanced'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Add-AnyStackNvmeInterface'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackNvmeDevice'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Remove-AnyStackNvmeInterface'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackNvmeQueueDepth'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackNvmeConnectivity'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Add-AnyStackNvmeInterface" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Add-AnyStackNvmeInterface' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackNvmeDevice" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackNvmeDevice' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Remove-AnyStackNvmeInterface" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackNvmeInterface' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackNvmeQueueDepth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackNvmeQueueDepth' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackNvmeConnectivity" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackNvmeConnectivity' | Should -Not -BeNullOrEmpty
        }
    }
}
