function Get-AnyStackLibraryItem {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Lists all items stored in the vSphere Content Libraries.
    .DESCRIPTION
        VCF.ContentManager. Implementation using Content Library service audit.
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
            # Content Libraries are managed via the CIS/REST API in modern vSphere
            $libraries = Get-ContentLibrary -Server $Server -ErrorAction SilentlyContinue

            foreach ($lib in $libraries) {
                $items = Get-ContentLibraryItem -ContentLibrary $lib -Server $Server -ErrorAction SilentlyContinue
                foreach ($item in $items) {
                    [PSCustomObject]@{
                        Timestamp   = (Get-Date)
                        Status      = 'Success'
                        Library     = $lib.Name
                        ItemName    = $item.Name
                        ItemType    = $item.ItemType
                        SizeGB      = [Math]::Round($item.SizeGB, 2)
                    }
                }
            }
        }
        catch {
            Write-Error "Failed to list Content Library items: $($_.Exception.Message)" -Category InvalidOperation
        }
    }
}
