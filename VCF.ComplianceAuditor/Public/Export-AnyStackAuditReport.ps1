function Export-AnyStackAuditReport {
    <#
    .SYNOPSIS
        Exports an audit report.
    .DESCRIPTION
        Calls Get-AnyStackNonCompliantHost and Invoke-AnyStackCisStigAudit.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER OutputPath
        Output HTML path.
    .EXAMPLE
        PS> Export-AnyStackAuditReport
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = ".\AuditReport-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting audit report on $($vi.Name)"
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-AnyStackNonCompliantHost -Server $vi -ClusterName $ClusterName -ErrorAction SilentlyContinue }
            
            $html = "<html><body><h1>Audit Report</h1>"
            $html += "<table border='1'><tr><th>Host</th><th>Findings Count</th></tr>"
            
            $findingCount = 0
            if ($null -ne $hosts) {
                foreach ($h in $hosts) {
                    $findings = Invoke-AnyStackWithRetry -ScriptBlock { Invoke-AnyStackCisStigAudit -Server $vi -HostName $h.Host -ErrorAction SilentlyContinue }
                    $count = if ($null -ne $findings) { $findings.FindingsCount } else { 0 }
                    $findingCount += $count
                    $html += "<tr><td>$($h.Host)</td><td>$count</td></tr>"
                }
            }
            $html += "</table></body></html>"
            Set-Content -Path $OutputPath -Value $html
            
            [PSCustomObject]@{
                PSTypeName        = 'AnyStack.AuditReport'
                Timestamp         = (Get-Date)
                Server            = $vi.Name
                ReportPath        = (Resolve-Path $OutputPath).Path
                HostsAudited      = if ($null -ne $hosts) { $hosts.Count } else { 0 }
                NonCompliantCount = if ($null -ne $hosts) { $hosts.Count } else { 0 }
                FindingCount      = $findingCount
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



