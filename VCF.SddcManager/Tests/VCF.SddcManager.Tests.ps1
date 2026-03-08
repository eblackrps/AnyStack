BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.SddcManager.psd1" -Force
}

Describe "VCF.SddcManager Suite" {
    Context "Get-AnyStackWorkloadDomain" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.SddcManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.SddcManager"
            Mock Invoke-RestMethod { return [PSCustomObject]@{Id='domain-1'; Name='WorkloadDomain01'; Type='VI'; Status='ACTIVE'; Clusters=@()} } -ModuleName "VCF.SddcManager"
            $result = Get-AnyStackWorkloadDomain -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Set-AnyStackPasswordRotation" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.SddcManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.SddcManager"
            Mock Invoke-RestMethod { return [PSCustomObject]@{Id='domain-1'; Name='WorkloadDomain01'; Type='VI'; Status='ACTIVE'; Clusters=@()} } -ModuleName "VCF.SddcManager"
            $result = Set-AnyStackPasswordRotation -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
    Context "Test-AnyStackSddcHealth" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.SddcManager"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.SddcManager"
            Mock Invoke-RestMethod { return [PSCustomObject]@{Id='domain-1'; Name='WorkloadDomain01'; Type='VI'; Status='ACTIVE'; Clusters=@()} } -ModuleName "VCF.SddcManager"
            $result = Test-AnyStackSddcHealth -Server 'mock' -ErrorAction SilentlyContinue
            $result | Should -Not -BeNullOrEmpty
            $result[0].PSTypeName | Should -Not -BeNullOrEmpty
        }
    }
}
 
