function Get-AnyStackDistributedPortgroup {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Retrieves all Distributed Portgroups for the connected vCenter.
    .DESCRIPTION
        VCF.NetworkManager. Implementation using targeted property fetching for performance.
    .INPUTS
        VMware.VimAutomation.Types.VIServer. Accepts a connected VIServer object via pipeline.
    .OUTPUTS
        PSCustomObject. Returns a result object with Timestamp, Status, and relevant data fields.
    .LINK
        https://github.com/eblackrps/AnyStack
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [VMware.VimAutomation.Types.VIServer]$Server
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            $pgs = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $Server -ViewType DistributedVirtualPortgroup -Property Name,Config.DefaultPortConfig.Vlan.VlanId,Key,Summary.PortgroupType }

            foreach ($pg in $pgs) {
                [PSCustomObject]@{
                    Timestamp   = (Get-Date)
                    Status      = 'Success'
                    Name        = $pg.Name
                    VlanId      = $pg.Config.DefaultPortConfig.Vlan.VlanId
                    Type        = $pg.Summary.PortgroupType
                    Key         = $pg.Key
                }
            }
        }
        catch {
            Write-Error "Failed to get distributed portgroups: $($_.Exception.Message)" -Category InvalidOperation
        }
    }
}
