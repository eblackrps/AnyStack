BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.ApplianceManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ApplianceManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ApplianceManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVcenterDiskSpace'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Restart-AnyStackVcenterService'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackVcenterBackup'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackVcenterDatabaseHealth'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVcenterDiskSpace" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVcenterDiskSpace' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackVcenterDiskSpace -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Restart-AnyStackVcenterService" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Restart-AnyStackVcenterService' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Restart-AnyStackVcenterService -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Start-AnyStackVcenterBackup" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackVcenterBackup' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Start-AnyStackVcenterBackup -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Test-AnyStackVcenterDatabaseHealth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVcenterDatabaseHealth' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Test-AnyStackVcenterDatabaseHealth -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
