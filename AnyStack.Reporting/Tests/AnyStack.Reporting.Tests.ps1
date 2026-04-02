BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\AnyStack.Reporting.psd1" -Force -ErrorAction Stop
}

Describe "AnyStack.Reporting Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'AnyStack.Reporting'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackHtmlReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackReport'] | Should -Not -BeNullOrEmpty
        }

        It "Should declare AnyStack.vSphere as a required module" {
            $manifest = Import-PowerShellDataFile "$PSScriptRoot\..\AnyStack.Reporting.psd1"
            ($manifest.RequiredModules | Where-Object { $_.ModuleName -eq 'AnyStack.vSphere' }) | Should -Not -BeNullOrEmpty
        }
    }

    Context "Export-AnyStackHtmlReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackHtmlReport' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Invoke-AnyStackReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackReport' | Should -Not -BeNullOrEmpty
        }
    }
}
