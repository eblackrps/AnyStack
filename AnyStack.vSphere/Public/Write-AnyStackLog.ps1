function Write-AnyStackLog {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Enterprise logging framework for AnyStack modules.
    .DESCRIPTION
        Round 9: Core Framework Enhancement. Standardizes console output,
    .INPUTS
        VMware.VimAutomation.Types.VIServer. Accepts a connected VIServer object via pipeline.
    .OUTPUTS
        PSCustomObject. Returns a result object with Timestamp, Status, and relevant data fields.
    .LINK
        https://github.com/eblackrps/AnyStack
        JSON logging, and transcript management across the suite.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)] [string]$Message,
        [Parameter(Mandatory=$false)] [ValidateSet('INFO','WARNING','ERROR','CRITICAL')] [string]$Level = 'INFO',
        [Parameter(Mandatory=$false)] [string]$LogFile
    )
    process {
        if ($null -eq $LogFile) {
            $LogFile = Join-Path $env:TEMP "AnyStack_Automation.log"
        }

        $timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        $logEntry = "[$timestamp] [$Level] $Message"

        # Console Output
        switch ($Level) {
            'INFO'     { Write-Verbose $logEntry }
            'WARNING'  { Write-Warning $logEntry }
            'ERROR'    { Write-Error $logEntry }
            'CRITICAL' { Write-Error "CRITICAL: $logEntry" }
        }

        # File Output (Append)
        if ($PSCmdlet.ShouldProcess($LogFile, "Write log entry to file")) {
            try {
                $logDir = [System.IO.Path]::GetDirectoryName($LogFile)
                if (-not (Test-Path $logDir)) {
                    New-Item -ItemType Directory -Path $logDir -Force | Out-Null
                }
                $logEntry | Out-File -FilePath $LogFile -Append -Encoding UTF8
            }
            catch {
                Write-Warning "Failed to write to log file $($LogFile): $($_.Exception.Message)"
            }
        }
    }
}


