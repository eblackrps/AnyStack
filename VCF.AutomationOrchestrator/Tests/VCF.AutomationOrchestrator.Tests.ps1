BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.AutomationOrchestrator.psd1" -Force -ErrorAction Stop
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
    }
    Context "New-AnyStackScheduledSnapshot" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackScheduledSnapshot' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackEventWebhook" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackEventWebhook' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Sync-AnyStackAutomationScripts" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackAutomationScripts' | Should -Not -BeNullOrEmpty
        }
    }
}
