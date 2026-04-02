function Get-AnyStackMacAddressConflict {
    <#
    .SYNOPSIS
        Detects duplicate MAC addresses in the environment.
    .DESCRIPTION
        Scans all VM virtual NICs and identifies overlapping MAC addresses.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackMacAddressConflict
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
        $Server
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Scanning for MAC conflicts on $($vi.Name)"
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Property Name,Config.Hardware.Device }
            
            $macs = @{}
            foreach ($vm in $vms) {
                $nics = $vm.Config.Hardware.Device | Where-Object { $_ -is [VMware.Vim.VirtualEthernetCard] }
                foreach ($nic in $nics) {
                    if (-not $macs.ContainsKey($nic.MacAddress)) { $macs[$nic.MacAddress] = @() }
                    $macs[$nic.MacAddress] += $vm.Name
                }
            }
            
            foreach ($mac in $macs.Keys) {
                if ($macs[$mac].Count -gt 1) {
                    [PSCustomObject]@{
                        PSTypeName   = 'AnyStack.MacConflict'
                        Timestamp    = (Get-Date)
                        Server       = $vi.Name
                        MacAddress   = $mac
                        AffectedVMs  = $macs[$mac] -join ','
                        ConflictType = 'Duplicate'
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
