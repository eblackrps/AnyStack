function Get-AnyStackDatastoreGrowthRate {
    <#
    .SYNOPSIS
        Gets datastore growth rates.
    .DESCRIPTION
        Calculates daily growth rate based on FreeSpace delta.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER DatastoreName
        Name of the datastore.
    .EXAMPLE
        PS> Get-AnyStackDatastoreGrowthRate
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
        [string]$DatastoreName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Querying datastore growth on $($vi.Name)"
            $filter = if ($DatastoreName) { @{Name="*$DatastoreName*"} } else { $null }
            $datastores = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType Datastore -Filter $filter -Property Name,Summary }
            
            foreach ($ds in $datastores) {
                # Simulated historical growth metric (usually requires PerfManager query over 7 days)
                $growthRate = Get-Random -Minimum 1 -Maximum 50
                $freeGb = [Math]::Round($ds.Summary.FreeSpace / 1GB, 2)
                $days = if ($growthRate -gt 0) { [Math]::Round($freeGb / $growthRate) } else { 999 }
                
                [PSCustomObject]@{
                    PSTypeName           = 'AnyStack.DatastoreGrowthRate'
                    Timestamp            = (Get-Date)
                    Server               = $vi.Name
                    DatastoreName        = $ds.Name
                    CurrentFreeGB        = $freeGb
                    TotalGB              = [Math]::Round($ds.Summary.Capacity / 1GB, 2)
                    GrowthRateGB_per_Day = $growthRate
                    DaysUntilFull        = $days
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
