BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\AnyStack.vSphere.psd1" -Force -ErrorAction Stop
}

Describe "AnyStack.vSphere Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'AnyStack.vSphere'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Connect-AnyStackServer'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Disconnect-AnyStackServer'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackClusterHostIdSet'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackConnection'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackHostView'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackLicenseUsage'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVcenterServices'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackVirtualMachineView'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackHealthCheck'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackWithRetry'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Write-AnyStackLog'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Connect-AnyStackServer" {
        BeforeEach {
            Mock Invoke-AnyStackWithRetry -ModuleName AnyStack.vSphere { throw "Simulated connection failure" }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Connect-AnyStackServer' | Should -Not -BeNullOrEmpty
        }

        It "Should throw when connection fails" {
            { Connect-AnyStackServer -Server 'nonexistent' -ErrorAction Stop } | Should -Throw
        }
    }

    Context "Get-AnyStackLicenseUsage" {
        BeforeEach {
            Mock Get-AnyStackConnection -ModuleName AnyStack.vSphere {
                [PSCustomObject]@{
                    Name        = 'ResolvedVC'
                    IsConnected = $true
                }
            }

            Mock Invoke-AnyStackWithRetry -ModuleName AnyStack.vSphere {
                [PSCustomObject]@{
                    Licenses = @(
                        [PSCustomObject]@{
                            Name       = 'vSphere Enterprise'
                            LicenseKey = 'AAAAA-BBBBB-CCCCC-DDDDD-EEEEE'
                            Total      = 10
                            Used       = 5
                        }
                    )
                }
            }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackLicenseUsage' | Should -Not -BeNullOrEmpty
        }

        It "Should report the resolved active connection" {
            $result = Get-AnyStackLicenseUsage -Server 'InputAlias'

            $result.Server | Should -Be 'ResolvedVC'
            $result.LicenseName | Should -Be 'vSphere Enterprise'
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
