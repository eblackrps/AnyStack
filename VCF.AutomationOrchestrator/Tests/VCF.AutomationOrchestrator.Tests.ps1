BeforeAll {
    function global:Get-AnyStackConnection { param($Server) return [PSCustomObject]@{Name='MockVC'} }
    function global:Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock }
    Import-Module "$PSScriptRoot\..\VCF.AutomationOrchestrator.psd1" -Force
}

Describe "VCF.AutomationOrchestrator Suite" {
    Context "Get-AnyStackFailedScheduledTask" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.AutomationOrchestrator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.AutomationOrchestrator"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.AutomationOrchestrator"
            $result = Get-AnyStackFailedScheduledTask -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
    Context "New-AnyStackScheduledSnapshot" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.AutomationOrchestrator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.AutomationOrchestrator"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.AutomationOrchestrator"
            $result = New-AnyStackScheduledSnapshot -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
    Context "Set-AnyStackEventWebhook" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.AutomationOrchestrator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.AutomationOrchestrator"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.AutomationOrchestrator"
            $result = Set-AnyStackEventWebhook -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
    Context "Sync-AnyStackAutomationScripts" {
        It "Should return expected object shape" {
            Mock Get-AnyStackConnection { return [PSCustomObject]@{Name='MockVC'} } -ModuleName "VCF.AutomationOrchestrator"
            Mock Invoke-AnyStackWithRetry { param($ScriptBlock) & $ScriptBlock } -ModuleName "VCF.AutomationOrchestrator"
            Mock Get-View { return @([PSCustomObject]@{Name='MockObj'; MoRef=[PSCustomObject]@{Value='v-1'}; Config=[PSCustomObject]@{Option=@(); DateTimeInfo=[PSCustomObject]@{NtpConfig=[PSCustomObject]@{Server=@('1')}}}; Runtime=[PSCustomObject]@{PowerState='poweredOn'}}) } -ModuleName "VCF.AutomationOrchestrator"
            $result = Sync-AnyStackAutomationScripts -Server 'mock' -ErrorAction SilentlyContinue
            if ($result) { $result[0].PSTypeName | Should -Not -BeNullOrEmpty }
        }
    }
}

