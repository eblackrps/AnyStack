BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.SecurityAdvanced.psd1" -Force -ErrorAction Stop
}

Describe "VCF.SecurityAdvanced Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.SecurityAdvanced'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Add-AnyStackNativeKeyProvider'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Disable-AnyStackHostSsh'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Enable-AnyStackHostSsh'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackEsxiLockdownMode'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Add-AnyStackNativeKeyProvider" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Add-AnyStackNativeKeyProvider' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Disable-AnyStackHostSsh" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Disable-AnyStackHostSsh' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Enable-AnyStackHostSsh" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Enable-AnyStackHostSsh' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackEsxiLockdownMode" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackEsxiLockdownMode' | Should -Not -BeNullOrEmpty
        }
    }
}
