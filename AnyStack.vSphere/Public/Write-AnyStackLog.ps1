function Write-AnyStackLog {
    <#
    .SYNOPSIS
        Writes a message to the AnyStack log.
    .DESCRIPTION
        Standardizes logging across the suite with timestamps and severity.
    .PARAMETER Message
        The message to log.
    .PARAMETER Level
        Severity level (Info, Warning, Error).
    .EXAMPLE
        PS> Write-AnyStackLog -Message 'Automation started' -Level Info
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [ValidateSet('Info','Warning','Error')]
        [string]$Level = 'Info'
    )
    process {
        $logObj = [PSCustomObject]@{
            PSTypeName = 'AnyStack.LogEntry'
            Timestamp  = (Get-Date)
            Level      = $Level
            Message    = $Message
        }
        $color = switch ($Level) {
            'Warning' { 'Yellow' }
            'Error'   { 'Red' }
            default   { 'Cyan' }
        }
        Write-Host "[$((Get-Date).ToString('HH:mm:ss'))] [$Level] $Message" -ForegroundColor $color
        return $logObj
    }
}
 

