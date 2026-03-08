function Get-AnyStackHostMemoryUsage {
    <#
    .SYNOPSIS
        Gets host memory usage.
    .DESCRIPTION
        Queries Summary.Hardware and QuickStats for memory.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackHostMemoryUsage
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching memory usage on $($vi.Name)"
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Property Name,Summary.Hardware.MemorySize,Summary.QuickStats }
            
            foreach ($h in $hosts) {
                $totalGb = [Math]::Round($h.Summary.Hardware.MemorySize / 1GB, 2)
                $usedGb = [Math]::Round($h.Summary.QuickStats.OverallMemoryUsage / 1024, 2)
                $usedPct = if ($totalGb -gt 0) { [Math]::Round(($usedGb / $totalGb) * 100, 1) } else { 0 }
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.HostMemoryUsage'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    Host       = $h.Name
                    TotalGB    = $totalGb
                    UsedGB     = $usedGb
                    UsedPct    = $usedPct
                    BalloonGB  = [Math]::Round($h.Summary.QuickStats.BalloonedMemory / 1024 / 1024, 2)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 

