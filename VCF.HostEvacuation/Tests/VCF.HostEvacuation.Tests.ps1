BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.HostEvacuation.psd1" -Force -ErrorAction Stop
}

Describe "VCF.HostEvacuation Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.HostEvacuation'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackHostEvacuation'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Stop-AnyStackHostEvacuation'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Start-AnyStackHostEvacuation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackHostEvacuation' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Stop-AnyStackHostEvacuation" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Stop-AnyStackHostEvacuation' | Should -Not -BeNullOrEmpty
        }
    }
}
