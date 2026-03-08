function Get-AnyStackMacAddressConflict {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Audits all VMs to identify duplicate MAC addresses on the network.
    .DESCRIPTION
        VCF.NetworkAudit. Scans all VM hardware configurations to detect MAC address conflicts.
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
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $Server -ViewType VirtualMachine -Property Name,Config.Hardware.Device }

            $macMap = @{}
            foreach ($vm in $vms) {
                $nics = $vm.Config.Hardware.Device | Where-Object { $_ -is [VMware.Vim.VirtualEthernetCard] }
                foreach ($nic in $nics) {
                    if (-not $macMap.ContainsKey($nic.MacAddress)) {
                        $macMap[$nic.MacAddress] = New-Object System.Collections.Generic.List[string]
                    }
                    $macMap[$nic.MacAddress].Add($vm.Name)
                }
            }

            foreach ($mac in $macMap.Keys) {
                if ($macMap[$mac].Count -gt 1) {
                    [PSCustomObject]@{
                        Timestamp = (Get-Date)
                        Status    = 'Conflict'
                        MacAddress = $mac
                        VMs       = $macMap[$mac] -join ', '
                    }
                }
            }
        }
        catch {
            Write-Error "Failed to audit MAC address conflicts: $($_.Exception.Message)" -Category InvalidOperation
        }
    }
}
