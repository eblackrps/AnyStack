BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\AnyStack.ConfigurationAsCode.psd1" -Force -ErrorAction Stop
}

Describe "AnyStack.ConfigurationAsCode Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'AnyStack.ConfigurationAsCode'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackConfiguration'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Sync-AnyStackConfiguration'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Export-AnyStackConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackConfiguration' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Sync-AnyStackConfiguration" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackConfiguration' | Should -Not -BeNullOrEmpty
        }
    }
}
