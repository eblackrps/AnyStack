BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.DRValidator.psd1" -Force -ErrorAction Stop
}

Describe "VCF.DRValidator Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.DRValidator'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackDRReadinessReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Repair-AnyStackDisasterRecoveryReadiness'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackVmBackup'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackDisasterRecoveryReadiness'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackDRReadinessReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackDRReadinessReport' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Export-AnyStackDRReadinessReport -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Repair-AnyStackDisasterRecoveryReadiness" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Repair-AnyStackDisasterRecoveryReadiness' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Repair-AnyStackDisasterRecoveryReadiness -Server 'MockVC' -VmName 'vm1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Start-AnyStackVmBackup" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackVmBackup' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Start-AnyStackVmBackup -Server 'MockVC' -VmName 'vm1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackDisasterRecoveryReadiness" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackDisasterRecoveryReadiness' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackDisasterRecoveryReadiness -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
