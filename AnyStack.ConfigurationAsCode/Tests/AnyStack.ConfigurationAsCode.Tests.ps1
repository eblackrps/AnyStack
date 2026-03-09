BeforeAll {
    # Stub all external dependencies globally before module load
    function global:Get-AnyStackConnection {
        param($Server)
        return [PSCustomObject]@{ Name = 'MockVC' }
    }
    function global:Invoke-AnyStackWithRetry {
        param($ScriptBlock)
        # Return safe stub data regardless of what the scriptblock does
        return @([PSCustomObject]@{ Name = 'Stub'; Type = 'VM'; DrsEnabled = $true; HaEnabled = $true })
    }
    function global:Get-Folder { return @([PSCustomObject]@{ Name = 'Folder1'; Type = 'VM' }) }
    function global:Get-Cluster { return @([PSCustomObject]@{ Name = 'Cluster1'; DrsEnabled = $true; HaEnabled = $true }) }

    Import-Module "$PSScriptRoot\..\AnyStack.ConfigurationAsCode.psd1" -Force
}

Describe "AnyStack.ConfigurationAsCode Suite" {
    Context "Export-AnyStackConfiguration" {
        It "Should return expected object shape" {
            $tempFile = [System.IO.Path]::GetTempFileName()
            try {
                $result = Export-AnyStackConfiguration -Server 'mock' -OutputPath $tempFile
                $result | Should -Not -BeNullOrEmpty
                $result.PSTypeName | Should -Be 'AnyStack.ConfigurationExport'
            }
            finally {
                if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
            }
        }
    }
    Context "Sync-AnyStackConfiguration" {
        It "Should return expected object shape" {
            $tempFile = [System.IO.Path]::GetTempFileName()
            try {
                '{"Server":"MockVC"}' | Set-Content -Path $tempFile -Encoding UTF8
                $result = Sync-AnyStackConfiguration -Server 'mock' -ConfigFilePath $tempFile -Confirm:$false
                $result | Should -Not -BeNullOrEmpty
                $result.PSTypeName | Should -Be 'AnyStack.ConfigurationSync'
            }
            finally {
                if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
            }
        }
    }
}
