BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.ContentManager.psd1" -Force -ErrorAction Stop
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
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackLibraryItem -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "New-AnyStackVmTemplate" {
        It "Should exist as an exported function" {
            Get-Command -Name 'New-AnyStackVmTemplate' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { New-AnyStackVmTemplate -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Remove-AnyStackOrphanedIso" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackOrphanedIso' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Remove-AnyStackOrphanedIso -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Sync-AnyStackContentLibrary" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackContentLibrary' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Sync-AnyStackContentLibrary -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
