BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.AlarmManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.AlarmManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.AlarmManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackActiveAlarm'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackActiveAlarm" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackActiveAlarm' | Should -Not -BeNullOrEmpty
        }
    }
}
