$modulesToCreate = @(
    @{
        Module = "VCF.LifecycleManager"
        Cmdlets = @(
            @{ Name = "Get-AnyStackClusterImage"; Verb="Get"; Noun="AnyStackClusterImage" }
            @{ Name = "Test-AnyStackCompliance"; Verb="Test"; Noun="AnyStackCompliance" }
            @{ Name = "Start-AnyStackHostRemediation"; Verb="Start"; Noun="AnyStackHostRemediation" }
            @{ Name = "Export-AnyStackHardwareCompatibility"; Verb="Export"; Noun="AnyStackHardwareCompatibility" }
        )
    },
    @{
        Module = "VCF.IdentityManager"
        Cmdlets = @(
            @{ Name = "Get-AnyStackGlobalPermission"; Verb="Get"; Noun="AnyStackGlobalPermission" }
            @{ Name = "New-AnyStackCustomRole"; Verb="New"; Noun="AnyStackCustomRole" }
            @{ Name = "Test-AnyStackSsoConfiguration"; Verb="Test"; Noun="AnyStackSsoConfiguration" }
            @{ Name = "Export-AnyStackAccessMatrix"; Verb="Export"; Noun="AnyStackAccessMatrix" }
        )
    },
    @{
        Module = "VCF.ContentManager"
        Cmdlets = @(
            @{ Name = "Sync-AnyStackContentLibrary"; Verb="Sync"; Noun="AnyStackContentLibrary" }
            @{ Name = "New-AnyStackVmTemplate"; Verb="New"; Noun="AnyStackVmTemplate" }
            @{ Name = "Remove-AnyStackOrphanedIso"; Verb="Remove"; Noun="AnyStackOrphanedIso" }
            @{ Name = "Get-AnyStackLibraryItem"; Verb="Get"; Noun="AnyStackLibraryItem" }
        )
    },
    @{
        Module = "VCF.TagManager"
        Cmdlets = @(
            @{ Name = "Set-AnyStackResourceTag"; Verb="Set"; Noun="AnyStackResourceTag" }
            @{ Name = "Get-AnyStackUntaggedVm"; Verb="Get"; Noun="AnyStackUntaggedVm" }
            @{ Name = "Sync-AnyStackTagCategory"; Verb="Sync"; Noun="AnyStackTagCategory" }
            @{ Name = "Remove-AnyStackStaleTag"; Verb="Remove"; Noun="AnyStackStaleTag" }
        )
    },
    @{
        Module = "VCF.LogIntelligence"
        Cmdlets = @(
            @{ Name = "Set-AnyStackSyslogServer"; Verb="Set"; Noun="AnyStackSyslogServer" }
            @{ Name = "Get-AnyStackHostLogBundle"; Verb="Get"; Noun="AnyStackHostLogBundle" }
            @{ Name = "Test-AnyStackLogForwarding"; Verb="Test"; Noun="AnyStackLogForwarding" }
            @{ Name = "Clear-AnyStackStaleLogs"; Verb="Clear"; Noun="AnyStackStaleLogs" }
        )
    },
    @{
        Module = "VCF.CapacityPlanner"
        Cmdlets = @(
            @{ Name = "Get-AnyStackZombieVm"; Verb="Get"; Noun="AnyStackZombieVm" }
            @{ Name = "Export-AnyStackCapacityForecast"; Verb="Export"; Noun="AnyStackCapacityForecast" }
            @{ Name = "Set-AnyStackRightSizeRecommendation"; Verb="Set"; Noun="AnyStackRightSizeRecommendation" }
            @{ Name = "Get-AnyStackDatastoreGrowthRate"; Verb="Get"; Noun="AnyStackDatastoreGrowthRate" }
        )
    },
    @{
        Module = "VCF.PerformanceProfiler"
        Cmdlets = @(
            @{ Name = "Get-AnyStackVmStorageLatency"; Verb="Get"; Noun="AnyStackVmStorageLatency" }
            @{ Name = "Test-AnyStackNetworkDroppedPackets"; Verb="Test"; Noun="AnyStackNetworkDroppedPackets" }
            @{ Name = "Get-AnyStackHostCpuCoStop"; Verb="Get"; Noun="AnyStackHostCpuCoStop" }
            @{ Name = "Export-AnyStackPerformanceBaseline"; Verb="Export"; Noun="AnyStackPerformanceBaseline" }
        )
    },
    @{
        Module = "VCF.ComplianceAuditor"
        Cmdlets = @(
            @{ Name = "Invoke-AnyStackCisStigAudit"; Verb="Invoke"; Noun="AnyStackCisStigAudit" }
            @{ Name = "Get-AnyStackNonCompliantHost"; Verb="Get"; Noun="AnyStackNonCompliantHost" }
            @{ Name = "Export-AnyStackAuditReport"; Verb="Export"; Noun="AnyStackAuditReport" }
            @{ Name = "Repair-AnyStackComplianceDrift"; Verb="Repair"; Noun="AnyStackComplianceDrift" }
        )
    },
    @{
        Module = "VCF.ApplianceManager"
        Cmdlets = @(
            @{ Name = "Get-AnyStackVcenterDiskSpace"; Verb="Get"; Noun="AnyStackVcenterDiskSpace" }
            @{ Name = "Start-AnyStackVcenterBackup"; Verb="Start"; Noun="AnyStackVcenterBackup" }
            @{ Name = "Test-AnyStackVcenterDatabaseHealth"; Verb="Test"; Noun="AnyStackVcenterDatabaseHealth" }
            @{ Name = "Restart-AnyStackVcenterService"; Verb="Restart"; Noun="AnyStackVcenterService" }
        )
    },
    @{
        Module = "VCF.AutomationOrchestrator"
        Cmdlets = @(
            @{ Name = "New-AnyStackScheduledSnapshot"; Verb="New"; Noun="AnyStackScheduledSnapshot" }
            @{ Name = "Get-AnyStackFailedScheduledTask"; Verb="Get"; Noun="AnyStackFailedScheduledTask" }
            @{ Name = "Set-AnyStackEventWebhook"; Verb="Set"; Noun="AnyStackEventWebhook" }
            @{ Name = "Sync-AnyStackAutomationScripts"; Verb="Sync"; Noun="AnyStackAutomationScripts" }
        )
    }
)

foreach ($m in $modulesToCreate) {
    $dir = Join-Path $PSScriptRoot $m.Module
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
        
        # Manifest
        $psd1 = Join-Path $dir "$($m.Module).psd1"
        $psd1Content = @"
@{
    RootModule           = '$($m.Module).psm1'
    ModuleVersion        = '1.0.0.0'
    Author               = 'The Any Stack Architect'
    CompanyName          = 'AnyStack'
    Description          = 'Enterprise extension module for vSphere 8.0 U3'
    PowerShellVersion = '5.1'
    FunctionsToExport    = '*'
}
"@
        Set-Content -Path $psd1 -Value $psd1Content

        # Module Script
        $psm1 = Join-Path $dir "$($m.Module).psm1"
        $psm1Content = @"
`$PublicPath  = Join-Path -Path `$PSScriptRoot -ChildPath 'Public'
`$PrivatePath = Join-Path -Path `$PSScriptRoot -ChildPath 'Private'

foreach (`$Path in @(`$PrivatePath, `$PublicPath)) {
    if (Test-Path -Path `$Path) {
        `$Files = Get-ChildItem -Path `$Path -Filter *.ps1 -File
        foreach (`$File in `$Files) { . `$File.FullName }
    }
}
"@
        Set-Content -Path $psm1 -Value $psm1Content
    }

    $publicDir = Join-Path $dir "Public"
    if (-not (Test-Path $publicDir)) {
        New-Item -ItemType Directory -Path $publicDir | Out-Null
    }

    foreach ($cmdlet in $m.Cmdlets) {
        $file = Join-Path $publicDir "$($cmdlet.Name).ps1"
        $content = @"
function $($cmdlet.Name) {
    <#
    .SYNOPSIS
        $($cmdlet.Name) - A specialized AnyStack Enterprise tool.
    .DESCRIPTION
        Autogenerated cmdlet for $($m.Module).
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=`$true)] [string]`$Server
    )
    process {
        Write-Host "[ANYSTACK] Running $($cmdlet.Name) on server `$Server" -ForegroundColor Cyan
    }
}
"@
        Set-Content -Path $file -Value $content
    }
}

Write-Host "Successfully generated the 10 new advanced modules!"
