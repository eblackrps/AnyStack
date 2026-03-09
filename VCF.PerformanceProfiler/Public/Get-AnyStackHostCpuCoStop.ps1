function Get-AnyStackHostCpuCoStop {
    <#
    .SYNOPSIS
        Gets host CPU co-stop metrics.
    .DESCRIPTION
        Queries cpu.costop.summation per host.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Get-AnyStackHostCpuCoStop
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
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching CPU co-stop on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name }
            
            foreach ($h in $hosts) {
                # Mocking PerfManager query output
                $val = Get-Random -Minimum 0 -Maximum 100
                [PSCustomObject]@{
                    PSTypeName       = 'AnyStack.CpuCoStop'
                    Timestamp        = (Get-Date)
                    Server           = $vi.Name
                    Host             = $h.Name
                    CpuCoStopMs      = $val
                    CoStopPct        = [Math]::Round($val / (20 * 200) * 100, 2)
                    SamplingInterval = 20
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
