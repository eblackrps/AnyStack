function Invoke-AnyStackReport {
    <#
    .SYNOPSIS
        Triggers a data collection report.
    .DESCRIPTION
        Runs an internal reporting job and returns results as objects.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Invoke-AnyStackReport
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
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Invoking data collection on $($vi.Name)"
            
            $summary = Invoke-AnyStackWithRetry -ScriptBlock { Get-VM -Server $vi | Measure-Object }
            
            [PSCustomObject]@{
                PSTypeName = 'AnyStack.DataReport'
                Timestamp  = (Get-Date)
                Status     = 'Success'
                Server     = $vi.Name
                VmCount    = $summary.Count
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
