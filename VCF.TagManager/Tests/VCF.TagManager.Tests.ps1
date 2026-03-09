BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\VCF.TagManager.psd1" -Force -ErrorAction Stop
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
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackUntaggedVm -Server 'MockVC' -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Remove-AnyStackStaleTag" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Remove-AnyStackStaleTag' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Remove-AnyStackStaleTag -Server 'MockVC' -TagName 'tag1' -CategoryName 'cat1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Set-AnyStackResourceTag" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Set-AnyStackResourceTag' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Set-AnyStackResourceTag -Server 'MockVC' -EntityName 'vm1' -TagName 'tag1' -CategoryName 'cat1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Sync-AnyStackTagCategory" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Sync-AnyStackTagCategory' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Sync-AnyStackTagCategory -Server 'MockVC' -CategoryName 'cat1' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
}
