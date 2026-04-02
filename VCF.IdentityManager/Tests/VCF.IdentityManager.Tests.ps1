BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.IdentityManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.IdentityManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.IdentityManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackAccessMatrix'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackGlobalPermission'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['New-AnyStackCustomRole'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackSsoConfiguration'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackAccessMatrix" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackAccessMatrix' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackGlobalPermission" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackGlobalPermission' | Should -Not -BeNullOrEmpty
        }
    }
    Context "New-AnyStackCustomRole" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackCustomRole' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackSsoConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackSsoConfiguration' | Should -Not -BeNullOrEmpty
        }
    }
}
