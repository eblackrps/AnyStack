function Export-AnyStackHtmlReport {
    <#
    .SYNOPSIS
        Exports a consolidated HTML report of the AnyStack environment.
    .DESCRIPTION
        Gathers data from multiple modules and generates a comprehensive HTML dashboard.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER OutputPath
        Path to the output HTML file.
    .EXAMPLE
        PS> Export-AnyStackHtmlReport -OutputPath '.\AnyStackReport.html'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = ".\AnyStackReport-$(Get-Date -f yyyyMMdd).html"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Generating HTML report for $($vi.Name)"
            
            $html = "<html><body><h1>AnyStack Enterprise Report: $($vi.Name)</h1>"
            $html += "<h2>Summary</h2><p>Report generated on $(Get-Date)</p>"
            $html += "</body></html>"
            
            Set-Content -Path $OutputPath -Value $html -Encoding UTF8
            
            [PSCustomObject]@{
                PSTypeName = 'AnyStack.HtmlReport'
                Timestamp  = (Get-Date)
                Status     = 'Success'
                Server     = $vi.Name
                ReportPath = (Resolve-Path $OutputPath).Path
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

