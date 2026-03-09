function Show-AnyStackSampleReport {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Generates a sample AnyStack Enterprise HTML report for demonstration.
    #>
    param(
        [string]$Path = "AnyStack-Sample-Report.html"
    )

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AnyStack Enterprise SDDC Report</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; color: #333; margin: 0; padding: 20px; }
        .container { max-width: 1000px; margin: auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        header { border-bottom: 3px solid #0078d4; padding-bottom: 10px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }
        h1 { color: #0078d4; margin: 0; font-size: 24px; }
        .status { padding: 5px 15px; border-radius: 20px; font-weight: bold; font-size: 14px; }
        .status-healthy { background: #dff6dd; color: #107c10; }
        .section { margin-bottom: 30px; }
        .section-title { font-size: 18px; font-weight: bold; border-left: 5px solid #0078d4; padding-left: 10px; margin-bottom: 15px; background: #f0f7ff; padding-top: 5px; padding-bottom: 5px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background-color: #f2f2f2; text-align: left; padding: 12px; border-bottom: 2px solid #ddd; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        .metric-card { display: flex; justify-content: space-around; margin-bottom: 20px; }
        .card { flex: 1; margin: 0 10px; padding: 15px; border-radius: 8px; text-align: center; color: white; }
        .card-blue { background: #0078d4; }
        .card-green { background: #107c10; }
        .card-orange { background: #d83b01; }
        .card-value { font-size: 28px; font-weight: bold; display: block; }
        .card-label { font-size: 12px; text-transform: uppercase; }
        footer { font-size: 12px; color: #777; text-align: center; margin-top: 40px; border-top: 1px solid #eee; padding-top: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>AnyStack Enterprise Report</h1>
            <span class="status status-healthy">Environment Healthy</span>
        </header>

        <div class="metric-card">
            <div class="card card-blue">
                <span class="card-value">1,248</span>
                <span class="card-label">Total VMs</span>
            </div>
            <div class="card card-green">
                <span class="card-value">98.4%</span>
                <span class="card-label">Uptime</span>
            </div>
            <div class="card card-orange">
                <span class="card-value">12.4 TB</span>
                <span class="card-label">Reclaimable Space</span>
            </div>
        </div>

        <div class="section">
            <div class="section-title">Cluster Performance Summary</div>
            <table>
                <thead>
                    <tr>
                        <th>Cluster Name</th>
                        <th>Hosts</th>
                        <th>CPU Usage</th>
                        <th>Memory Usage</th>
                        <th>vSAN Health</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Production-Cluster-01</td>
                        <td>32</td>
                        <td>42%</td>
                        <td>68%</td>
                        <td><span style="color: #107c10;">● Healthy</span></td>
                    </tr>
                    <tr>
                        <td>Management-Cluster-01</td>
                        <td>8</td>
                        <td>15%</td>
                        <td>30%</td>
                        <td><span style="color: #107c10;">● Healthy</span></td>
                    </tr>
                    <tr>
                        <td>VDI-Desktop-Cluster</td>
                        <td>16</td>
                        <td>78%</td>
                        <td>85%</td>
                        <td><span style="color: #d83b01;">● Warning</span></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div class="section">
            <div class="section-title">Critical Compliance Alerts</div>
            <table>
                <thead>
                    <tr>
                        <th>Module</th>
                        <th>Check</th>
                        <th>Status</th>
                        <th>Details</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>SecurityBaseline</td>
                        <td>ESXi SSH Status</td>
                        <td><span style="color: #d83b01;">Warning</span></td>
                        <td>3 Hosts have SSH enabled (Violates STIG V-123)</td>
                    </tr>
                    <tr>
                        <td>CertificateManager</td>
                        <td>Host Cert Expiry</td>
                        <td><span style="color: #107c10;">Pass</span></td>
                        <td>All certificates valid for > 90 days</td>
                    </tr>
                    <tr>
                        <td>DRValidator</td>
                        <td>Snapshot Age</td>
                        <td><span style="color: #a80000;">Fail</span></td>
                        <td>12 VMs have snapshots older than 72 hours</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <footer>
            Generated by AnyStack.Reporting v1.6.5 | Report ID: RPT-$(Get-Date -Format 'yyyyMMddHHmmss')
        </footer>
    </div>
</body>
</html>
"@
    Set-Content -Path $Path -Value $html
    Write-Host "Sample report generated at: $Path" -ForegroundColor Green
}

Show-AnyStackSampleReport

 






