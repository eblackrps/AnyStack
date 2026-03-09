function Export-AnyStackDRReadinessReport {
    <#
    .SYNOPSIS
        Exports a DR readiness report.
    .DESCRIPTION
        Calls Test-AnyStackDisasterRecoveryReadiness internally and exports HTML.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER OutputPath
        Output HTML path.
    .EXAMPLE
        PS> Export-AnyStackDRReadinessReport
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
        [string]$OutputPath = ".\DR-Readiness-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting DR report on $($vi.Name)"
            $results = Invoke-AnyStackWithRetry -ScriptBlock { Test-AnyStackDisasterRecoveryReadiness -Server $vi -ErrorAction SilentlyContinue }
            
            $html = "<html><body><h1>DR Readiness</h1><table border='1'><tr><th>VM</th><th>Ready</th></tr>"
            $ready = 0
            $notReady = 0
            if ($null -ne $results) {
                foreach ($r in $results) {
                    if ($r.OverallReady) { $ready++ } else { $notReady++ }
                    $html += "<tr><td>$($r.VmName)</td><td>$($r.OverallReady)</td></tr>"
                }
            }
            $html += "</table></body></html>"
            Set-Content -Path $OutputPath -Value $html
            
            [PSCustomObject]@{
                PSTypeName    = 'AnyStack.DRReport'
                Timestamp     = (Get-Date)
                Server        = $vi.Name
                ReportPath    = (Resolve-Path $OutputPath).Path
                VmsChecked    = if ($null -ne $results) { $results.Count } else { 0 }
                ReadyCount    = $ready
                NotReadyCount = $notReady
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



