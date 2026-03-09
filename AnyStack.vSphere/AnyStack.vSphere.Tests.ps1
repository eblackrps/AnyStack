BeforeAll {
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC'; IsConnected = $true }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock, $MaxAttempts = 3, $DelaySeconds = 2)
        return $null
    }
    Import-Module "$PSScriptRoot\..\AnyStack.vSphere.psd1" -Force -ErrorAction Stop
}

Describe "AnyStack.vSphere Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'AnyStack.vSphere'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Connect-AnyStackServer'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Disconnect-AnyStackServer'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackLicenseUsage'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVcenterServices'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackHealthCheck'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Write-AnyStackLog'] | Should -Not -BeNullOrEmpty
        }
    }
    Context "Connect-AnyStackServer" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Connect-AnyStackServer' | Should -Not -BeNullOrEmpty
        }
        It "Should throw when connection fails" {
            { Connect-AnyStackServer -Server 'nonexistent' -ErrorAction Stop } | Should -Throw
        }
    }
    Context "Disconnect-AnyStackServer" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Disconnect-AnyStackServer' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Disconnect-AnyStackServer -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackLicenseUsage" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackLicenseUsage' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackLicenseUsage -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Get-AnyStackVcenterServices" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackVcenterServices' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Get-AnyStackVcenterServices -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Invoke-AnyStackHealthCheck" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackHealthCheck' | Should -Not -BeNullOrEmpty
        }
        It "Should be callable without throwing a syntax error" {
            { Invoke-AnyStackHealthCheck -Server 'MockVC' -Confirm:$false -ErrorAction SilentlyContinue } | Should -Not -Throw
        }
    }
    Context "Write-AnyStackLog" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Write-AnyStackLog' | Should -Not -BeNullOrEmpty
        }
        It "Should return a log entry without a connection" {
            $result = Write-AnyStackLog -Message 'test' -Level Info
            $result.PSTypeNames[0] | Should -Be 'AnyStack.LogEntry'
        }
    }
}
