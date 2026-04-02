BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.ApplianceManager.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ApplianceManager Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ApplianceManager'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVcenterDiskSpace'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Restart-AnyStackVcenterService'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Start-AnyStackVcenterBackup'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackVcenterDatabaseHealth'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVcenterDiskSpace" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVcenterDiskSpace' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Restart-AnyStackVcenterService" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Restart-AnyStackVcenterService' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Start-AnyStackVcenterBackup" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Start-AnyStackVcenterBackup' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackVcenterDatabaseHealth" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVcenterDatabaseHealth' | Should -Not -BeNullOrEmpty
        }
    }
}
