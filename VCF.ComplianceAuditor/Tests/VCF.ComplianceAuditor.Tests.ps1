BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\VCF.ComplianceAuditor.psd1" -Force -ErrorAction Stop
}

Describe "VCF.ComplianceAuditor Suite" {
    Context "Module" {
        It "Should load and export all expected functions" {
            $m = Get-Module -Name 'VCF.ComplianceAuditor'
            $m | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Export-AnyStackAuditReport'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Get-AnyStackNonCompliantHost'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Invoke-AnyStackCisStigAudit'] | Should -Not -BeNullOrEmpty
            $m.ExportedFunctions['Repair-AnyStackComplianceDrift'] | Should -Not -BeNullOrEmpty
        }
    }

    Context "Export-AnyStackAuditReport" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Export-AnyStackAuditReport' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Get-AnyStackNonCompliantHost" {
        BeforeEach {
            $script:complianceTaskRequests = 0
            $script:taskWaitRequests = 0

            $script:profileManager = [PSCustomObject]@{}
            $script:profileManager | Add-Member -MemberType ScriptMethod -Name CheckCompliance_Task -Value {
                param($hostRefs)
                [PSCustomObject]@{ Value = 'task-002' }
            }

            Mock Get-AnyStackConnection -ModuleName VCF.ComplianceAuditor {
                [PSCustomObject]@{
                    Name          = 'ResolvedVC'
                    IsConnected   = $true
                    ExtensionData = [PSCustomObject]@{
                        Content = [PSCustomObject]@{
                            HostProfileManager = 'profile-1'
                        }
                    }
                }
            }

            Mock Get-AnyStackHostView -ModuleName VCF.ComplianceAuditor {
                @(
                    [PSCustomObject]@{
                        Name  = 'esx01'
                        MoRef = [PSCustomObject]@{ Value = 'host-1' }
                        Config = [PSCustomObject]@{}
                    }
                )
            }

            Mock Invoke-AnyStackWithRetry -ModuleName VCF.ComplianceAuditor {
                param($ScriptBlock)

                $scriptText = $ScriptBlock.ToString()

                if ($scriptText -like '*HostProfileManager*') {
                    return $script:profileManager
                }

                if ($scriptText -like '*CheckCompliance_Task*') {
                    $script:complianceTaskRequests++
                    return [PSCustomObject]@{ Value = 'task-002' }
                }

                if ($scriptText -like '*Get-Task -Id*') {
                    $script:taskWaitRequests++
                    return $null
                }

                if ($scriptText -like '*.Info.Result*') {
                    return @(
                        [PSCustomObject]@{
                            Entity           = [PSCustomObject]@{ Value = 'host-1' }
                            ComplianceStatus = 'nonCompliant'
                            Failure          = @(
                                [PSCustomObject]@{ Message = 'NTP is not configured.' }
                            )
                        }
                    )
                }

                throw "Unexpected script block: $scriptText"
            }
        }

        It "Should exist as an exported function" {
            Get-Command -Name 'Get-AnyStackNonCompliantHost' | Should -Not -BeNullOrEmpty
        }

        It "Should return non-compliant hosts during normal execution" {
            $result = Get-AnyStackNonCompliantHost -Server 'InputVC' -ClusterName 'ClusterA' -Confirm:$false

            $result.Server | Should -Be 'ResolvedVC'
            $result.Host | Should -Be 'esx01'
            $result.NonCompliantSettings | Should -Contain 'NTP is not configured.'
            Assert-MockCalled Get-AnyStackHostView -ModuleName VCF.ComplianceAuditor -Times 1 -ParameterFilter { $ClusterName -eq 'ClusterA' }
            $script:complianceTaskRequests | Should -Be 1
            $script:taskWaitRequests | Should -Be 1
        }

        It "Should not run the compliance task when -WhatIf is used" {
            $result = @(Get-AnyStackNonCompliantHost -Server 'InputVC' -ClusterName 'ClusterA' -WhatIf)

            $result.Count | Should -Be 0
            $script:complianceTaskRequests | Should -Be 0
            $script:taskWaitRequests | Should -Be 0
        }
    }

    Context "Invoke-AnyStackCisStigAudit" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Invoke-AnyStackCisStigAudit' | Should -Not -BeNullOrEmpty
        }
    }

    Context "Repair-AnyStackComplianceDrift" {
        It "Should exist as an exported function" {
            Get-Command -Name 'Repair-AnyStackComplianceDrift' | Should -Not -BeNullOrEmpty
        }
    }
}
