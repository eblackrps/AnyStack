BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\\..\\VCF.ResourceAudit.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ResourceAudit Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ResourceAudit'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostMemoryUsage'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackOrphanedState'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVmMigrationHistory'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVmUptime'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Move-AnyStackVmDatastore'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Remove-AnyStackOldTemplates'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Restart-AnyStackVmTools'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Set-AnyStackVmResourcePool'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Test-AnyStackVmCpuReady'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Update-AnyStackVmHardware'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Update-AnyStackVmTools'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackHostMemoryUsage" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackHostMemoryUsage' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackOrphanedState" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackOrphanedState' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVmMigrationHistory" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmMigrationHistory' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Get-AnyStackVmUptime" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVmUptime' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Move-AnyStackVmDatastore" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Move-AnyStackVmDatastore' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Remove-AnyStackOldTemplates" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackOldTemplates' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Restart-AnyStackVmTools" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Restart-AnyStackVmTools' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackVmResourcePool" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackVmResourcePool' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackVmCpuReady" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Test-AnyStackVmCpuReady' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Update-AnyStackVmHardware" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackVmHardware' | Should -Not -BeNullOrEmpty
        }
    }
    Context "Update-AnyStackVmTools" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Update-AnyStackVmTools' | Should -Not -BeNullOrEmpty
        }
    }
}
