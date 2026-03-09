BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.SnapshotManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SnapshotManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SnapshotManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Clear-AnyStackOrphanedSnapshots'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Optimize-AnyStackSnapshots'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Clear-AnyStackOrphanedSnapshots" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Clear-AnyStackOrphanedSnapshots' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Clear-AnyStackOrphanedSnapshots -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Optimize-AnyStackSnapshots" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Optimize-AnyStackSnapshots' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Optimize-AnyStackSnapshots -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
