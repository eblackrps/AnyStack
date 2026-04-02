BeforeAll {
    $env:PSModulePath = "$(Resolve-Path (Join-Path $PSScriptRoot '..\..'));$env:PSModulePath"
    Import-Module "$PSScriptRoot\..\AnyStack.vSphere.psd1" -Force -ErrorAction Stop
}

Describe "AnyStack.vSphere Connection Helpers" {
    AfterEach {
        Remove-Variable -Name DefaultVIServers -Scope Global -ErrorAction SilentlyContinue
        Remove-Variable -Name DefaultVIServer -Scope Global -ErrorAction SilentlyContinue
    }

    It "returns the active connection when Server is omitted" {
        $global:DefaultVIServers = @(
            [PSCustomObject]@{
                Name        = 'DefaultVC'
                IsConnected = $true
            }
        )

        $result = Get-AnyStackConnection
        $result.Name | Should -Be 'DefaultVC'
    }

    It "returns the named active connection when Server is a string" {
        $global:DefaultVIServers = @(
            [PSCustomObject]@{
                Name        = 'TargetVC'
                IsConnected = $true
            }
        )

        $result = Get-AnyStackConnection -Server 'TargetVC'
        $result.Name | Should -Be 'TargetVC'
    }

    It "throws when a named connection is not active" {
        $global:DefaultVIServers = @(
            [PSCustomObject]@{
                Name        = 'OtherVC'
                IsConnected = $true
            }
        )

        { Get-AnyStackConnection -Server 'MissingVC' } | Should -Throw "Not connected to vCenter Server 'MissingVC'*"
    }

    It "throws when no active connection exists and Server is omitted" {
        { Get-AnyStackConnection } | Should -Throw 'No active vCenter Server connection found*'
    }

    It "accepts a connected server object directly" {
        $server = [PSCustomObject]@{
            Name        = 'ObjectVC'
            IsConnected = $true
        }

        $result = Get-AnyStackConnection -Server $server
        $result.Name | Should -Be 'ObjectVC'
    }

    It "throws when multiple active connections exist and Server is omitted" {
        $global:DefaultVIServers = @(
            [PSCustomObject]@{ Name = 'VC1'; IsConnected = $true }
            [PSCustomObject]@{ Name = 'VC2'; IsConnected = $true }
        )

        { Get-AnyStackConnection } | Should -Throw 'Multiple active vCenter Server connections found*'
    }

    It "uses pipeline input in health checks" {
        Mock Invoke-AnyStackWithRetry -ModuleName AnyStack.vSphere {
            param($ScriptBlock)

            if ($ScriptBlock.ToString() -like '*QueryHealthStatus()*') {
                return [PSCustomObject]@{ OverallHealth = 'Healthy' }
            }

            return [PSCustomObject]@{ Name = 'HealthManager' }
        }

        $result = [PSCustomObject]@{
            Name        = 'PipeVC'
            IsConnected = $true
            ExtensionData = [PSCustomObject]@{
                Content = [PSCustomObject]@{
                    HealthStatusManager = 'health-status-manager'
                }
            }
        } | Invoke-AnyStackHealthCheck

        $result.Server | Should -Be 'PipeVC'
        $result.DatabaseState | Should -Be 'Healthy'
    }

    It "accepts omitted Server when a single connection is active" {
        Mock Invoke-AnyStackWithRetry -ModuleName AnyStack.vSphere {
            param($ScriptBlock)

            if ($ScriptBlock.ToString() -like '*QueryHealthStatus()*') {
                return [PSCustomObject]@{ OverallHealth = 'Healthy' }
            }

            return [PSCustomObject]@{ Name = 'HealthManager' }
        }

        $global:DefaultVIServers = @(
            [PSCustomObject]@{
                Name        = 'ImplicitVC'
                IsConnected = $true
                ExtensionData = [PSCustomObject]@{
                    Content = [PSCustomObject]@{
                        HealthStatusManager = 'health-status-manager'
                    }
                }
            }
        )

        $result = Invoke-AnyStackHealthCheck

        $result.Server | Should -Be 'ImplicitVC'
        $result.DatabaseState | Should -Be 'Healthy'
    }
}

