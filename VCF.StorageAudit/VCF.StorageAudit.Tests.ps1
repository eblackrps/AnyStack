BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.StorageAudit.psd1" -Force -ErrorAction Stop
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
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackDatastoreIops -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackDatastoreLatency" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackDatastoreLatency' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackDatastoreLatency -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackOrphanedVmdk" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackOrphanedVmdk' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackOrphanedVmdk -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackVmDiskLatency" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmDiskLatency' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackVmDiskLatency -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackVsanHealth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVsanHealth' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackVsanHealth -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Invoke-AnyStackDatastoreUnmount" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackDatastoreUnmount' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Invoke-AnyStackDatastoreUnmount -Server 'MockVC' -DatastoreName 'ds1' -HostName 'esxi1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackDatastorePathMultipathing" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackDatastorePathMultipathing' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackDatastorePathMultipathing -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackStorageConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackStorageConfiguration' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackStorageConfiguration -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackVsanCapacity" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVsanCapacity' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackVsanCapacity -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
