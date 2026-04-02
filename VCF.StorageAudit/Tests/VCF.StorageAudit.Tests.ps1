BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.StorageAudit.psd1" -Force -ErrorAction Stop
}

Describe "VCF.StorageAudit Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.StorageAudit'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackDatastoreIops'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackDatastoreLatency'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackOrphanedVmdk'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVmDiskLatency'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVsanHealth'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackDatastoreUnmount'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackDatastorePathMultipathing'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackStorageConfiguration'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackVsanCapacity'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackDatastoreIops" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackDatastoreIops' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackDatastoreLatency" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackDatastoreLatency' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackOrphanedVmdk" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackOrphanedVmdk' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVmDiskLatency" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmDiskLatency' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVsanHealth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVsanHealth' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Invoke-AnyStackDatastoreUnmount" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackDatastoreUnmount' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackDatastorePathMultipathing" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackDatastorePathMultipathing' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackStorageConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackStorageConfiguration' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackVsanCapacity" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVsanCapacity' | Should -Not -BeNullOrEmpty
        }
    }
}
