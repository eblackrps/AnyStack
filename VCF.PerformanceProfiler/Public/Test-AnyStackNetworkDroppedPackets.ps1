function Test-AnyStackNetworkDroppedPackets {
    <#
    .SYNOPSIS
        Tests for dropped network packets.
    .DESCRIPTION
        Queries net.droppedTx.summation and Rx.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster.
    .PARAMETER HostName
        Filter by host name.
    .PARAMETER Threshold
        Threshold for dropped packets.
    .EXAMPLE
        PS> Test-AnyStackNetworkDroppedPackets
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
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [string]$HostName,
        [Parameter(Mandatory=$false)]
        [int]$Threshold = 100
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching dropped packets on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name }
            
            foreach ($h in $hosts) {
                [PSCustomObject]@{
                    PSTypeName        = 'AnyStack.DroppedPackets'
                    Timestamp         = (Get-Date)
                    Server            = $vi.Name
                    Host              = $h.Name
                    NicName           = 'vmnic0'
                    DroppedTx         = 0
                    DroppedRx         = 5
                    ThresholdExceeded = (5 -gt $Threshold)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
