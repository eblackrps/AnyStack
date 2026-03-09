BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\AnyStack.ConfigurationAsCode.psd1" -Force
}

Describe "AnyStack.ConfigurationAsCode Suite" {
    Context "Export-AnyStackConfiguration" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.ConfigurationAsCode"
            Mock Invoke-AnyStackWithRetry {
                param($ScriptBlock)
                return @([PSCustomObject]@{Name='Folder1'; Type='VM'})
            } -ModuleName "AnyStack.ConfigurationAsCode"

            $tempFile = [System.IO.Path]::GetTempFileName()
            try {
                $result = Export-AnyStackConfiguration -Server 'mock' -OutputPath $tempFile -ErrorAction SilentlyContinue
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
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "AnyStack.ConfigurationAsCode"

            $tempFile = [System.IO.Path]::GetTempFileName()
            try {
                '{"Server":"MockVC"}' | Set-Content -Path $tempFile
                $result = Sync-AnyStackConfiguration -Server 'mock' -ConfigFilePath $tempFile -Confirm:$false -ErrorAction SilentlyContinue
                $result | Should -Not -BeNullOrEmpty
                $result.PSTypeName | Should -Be 'AnyStack.ConfigurationSync'
            }
            finally {
                if (Test-Path $tempFile) { Remove-Item $tempFile -Force }
            }
        }
    }
}
