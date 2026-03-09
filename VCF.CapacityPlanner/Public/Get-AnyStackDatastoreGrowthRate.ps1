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
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
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
                $freeGb = [Math]::Round($ds.Summary.FreeSpace / 1GB, 2)
                $growthRate = $null
                $days = $null
                
                $dsObj = Get-Datastore -Id $ds.MoRef -Server $vi
                $stats = Get-Stat -Entity $dsObj -Stat disk.used.latest -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -ErrorAction SilentlyContinue
                if ($null -ne $stats -and $stats.Count -ge 2) {
                    $first = $stats[0].Value
                    $last = $stats[-1].Value
                    $deltaKb = $last - $first
                    $dailyDeltaGb = ($deltaKb / 1MB) / 7
                    $growthRate = [Math]::Round($dailyDeltaGb, 2)
                    if ($growthRate -gt 0) {
                        $days = [Math]::Round($freeGb / $growthRate)
                    }
                } else {
                    Write-Warning "Insufficient history (< 2 data points) for datastore $($ds.Name)."
                }
                
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
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Get-AnyStackDatastoreGrowthRate {
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
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
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
                $freeGb = [Math]::Round($ds.Summary.FreeSpace / 1GB, 2)
                $growthRate = $null
                $days = $null
                
                $dsObj = Get-Datastore -Id $ds.MoRef -Server $vi
                $stats = Get-Stat -Entity $dsObj -Stat disk.used.latest -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -ErrorAction SilentlyContinue
                if ($null -ne $stats -and $stats.Count -ge 2) {
                    $first = $stats[0].Value
                    $last = $stats[-1].Value
                    $deltaKb = $last - $first
                    $dailyDeltaGb = ($deltaKb / 1MB) / 7
                    $growthRate = [Math]::Round($dailyDeltaGb, 2)
                    if ($growthRate -gt 0) {
                        $days = [Math]::Round($freeGb / $growthRate)
                    }
                } else {
                    Write-Warning "Insufficient history (< 2 data points) for datastore $($ds.Name)."
                }
                
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
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 




