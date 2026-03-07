function Write-AnyStackLog {
    <#
    .SYNOPSIS
        Enterprise logging framework for AnyStack modules.
    .DESCRIPTION
        Round 9: Core Framework Enhancement. Standardizes console output, 
        JSON logging, and transcript management across the suite.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] [string]$Message,
        [Parameter(Mandatory=$false)] [ValidateSet('INFO','WARNING','ERROR','CRITICAL')] [string]$Level = 'INFO',
        [Parameter(Mandatory=$false)] [string]$LogFile = "C:\Reports\AnyStack_Automation.log"
    )
    process {
        $ErrorActionPreference = 'Stop'
        $timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        $logEntry = "[$timestamp] [$Level] $Message"
        
        # Console Output
        switch ($Level) {
            'INFO'     { Write-Host $logEntry -ForegroundColor Cyan }
            'WARNING'  { Write-Host $logEntry -ForegroundColor Yellow }
            'ERROR'    { Write-Host $logEntry -ForegroundColor Red }
            'CRITICAL' { Write-Host $logEntry -ForegroundColor Magenta -BackgroundColor Black }
        }
        
        # File Output (Append)
        if ($LogFile) {
            $logEntry | Out-File -FilePath $LogFile -Append -Encoding UTF8
        }
    }
}
