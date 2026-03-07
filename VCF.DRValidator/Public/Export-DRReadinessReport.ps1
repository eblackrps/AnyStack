function Export-DRReadinessReport {
    <#
    .SYNOPSIS
        Generates an executive HTML report for DR Readiness.

    .DESCRIPTION
        Consolidates the output objects from Test-DisasterRecoveryReadiness into a structured, color-coded HTML report.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [psobject[]]$DRResults,
        
        [Parameter(Mandatory=$true)]
        [string]$Path
    )
    begin {
        $allResults = @()
    }
    process {
        $ErrorActionPreference = 'Stop'
        $allResults += $DRResults
    }
    end {
        Write-Verbose "Generating HTML report..."
        $htmlHead = @"
<style>
    body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; color: #333; margin: 20px; }
    h2 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; }
    table { border-collapse: collapse; width: 100%; box-shadow: 0 2px 3px rgba(0,0,0,0.1); background-color: #fff; }
    th, td { border: 1px solid #ddd; padding: 12px; text-align: left; font-size: 14px; }
    th { background-color: #34495e; color: #fff; text-transform: uppercase; letter-spacing: 0.05em; }
    .ready { border-left: 5px solid #2ecc71; }
    .not-ready { border-left: 5px solid #e74c3c; background-color: #fdf2f2; }
    .badge { padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 12px; }
    .badge-success { background-color: #d5f5e3; color: #1e8449; }
    .badge-error { background-color: #fadbd8; color: #c0392b; }
</style>
"@
        
        $htmlBody = "<h2>AnyStack DR Readiness Executive Summary</h2>"
        $htmlBody += "<table><tr><th>VM Name</th><th>DR Ready</th><th>CBT</th><th>Tools Status</th><th>Storage Violations</th><th>Network/Rule Violations</th><th>Resource Violations</th></tr>"
        
        foreach ($res in $allResults) {
            $rowClass = if ($res.DRReady) { "ready" } else { "not-ready" }
            $readyBadge = if ($res.DRReady) { "<span class='badge badge-success'>READY</span>" } else { "<span class='badge badge-error'>NOT READY</span>" }
            $cbtBadge = if ($res.CBTEnabled) { "<span class='badge badge-success'>TRUE</span>" } else { "<span class='badge badge-error'>FALSE</span>" }
            
            $htmlBody += "<tr class='$rowClass'>
                <td><b>$($res.VMName)</b></td>
                <td>$readyBadge</td>
                <td>$cbtBadge</td>
                <td>$($res.ToolsStatus)</td>
                <td>$($res.StorageBlockers)</td>
                <td>$($res.NetworkOrRuleFlags)</td>
                <td>$($res.ResourceConstraints)</td>
            </tr>"
        }
        $htmlBody += "</table>"
        
        $finalHtml = "<html><head><title>DR Readiness Report</title>$htmlHead</head><body>$htmlBody</body></html>"
        $finalHtml | Out-File -FilePath $Path -Encoding UTF8
        Write-Verbose "Successfully saved DR Report to $Path"
    }
}
