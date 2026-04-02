BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.TagManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.TagManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.TagManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackUntaggedVm'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Remove-AnyStackStaleTag'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackResourceTag'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Sync-AnyStackTagCategory'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackUntaggedVm" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackUntaggedVm' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Remove-AnyStackStaleTag" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackStaleTag' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackResourceTag" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackResourceTag' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Sync-AnyStackTagCategory" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackTagCategory' | Should -Not -BeNullOrEmpty
        }
    }
}
