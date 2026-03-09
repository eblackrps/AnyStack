BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.AutomationOrchestrator.psd1" -Force -ErrorAction Stop
}

Describe "VCF.AutomationOrchestrator Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.AutomationOrchestrator'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackFailedScheduledTask'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['New-AnyStackScheduledSnapshot'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackEventWebhook'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Sync-AnyStackAutomationScripts'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackFailedScheduledTask" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackFailedScheduledTask' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackFailedScheduledTask -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "New-AnyStackScheduledSnapshot" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackScheduledSnapshot' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { New-AnyStackScheduledSnapshot -Server 'MockVC' -VmName 'vm1' -SnapshotName 'snap1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackEventWebhook" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackEventWebhook' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackEventWebhook -Server 'MockVC' -WebhookUrl 'https://fake.url' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Sync-AnyStackAutomationScripts" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackAutomationScripts' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Sync-AnyStackAutomationScripts -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
