function Get-AnyStackUntaggedVm {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Identifies virtual machines that have no tags assigned.
    .DESCRIPTION
        VCF.TagManager. Audits all VMs and cross-references with the tagging service.
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
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $Server -ViewType VirtualMachine -Property Name }

            foreach ($vm in $vms) {
                # Get-TagAssignment is the standard PowerCLI way for tags
                $tags = Get-TagAssignment -Entity $vm.Name -Server $Server -ErrorAction SilentlyContinue

                if ($null -eq $tags -or $tags.Count -eq 0) {
                    [PSCustomObject]@{
                        Timestamp = (Get-Date)
                        Status    = 'Untagged'
                        VMName    = $vm.Name
                    }
                }
            }
        }
        catch {
            Write-Error "Failed to identify untagged VMs: $($_.Exception.Message)" -Category InvalidOperation
        }
    }
}
