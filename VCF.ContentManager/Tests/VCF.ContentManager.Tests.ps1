BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.ContentManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ContentManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ContentManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackLibraryItem'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['New-AnyStackVmTemplate'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Remove-AnyStackOrphanedIso'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Sync-AnyStackContentLibrary'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackLibraryItem" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackLibraryItem' | Should -Not -BeNullOrEmpty
        }
    }
    Context "New-AnyStackVmTemplate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackVmTemplate' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Remove-AnyStackOrphanedIso" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackOrphanedIso' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Sync-AnyStackContentLibrary" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackContentLibrary' | Should -Not -BeNullOrEmpty
        }
    }
}
