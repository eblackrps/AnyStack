function Get-AnyStackConnection {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        $Server
    )

    if ($Server -is [VMware.VimAutomation.Types.VIServer]) {
        return $Server
    }

    if ($Server -is [string]) {
        $vi = Get-VIServer -Name $Server -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -eq $vi) {
            throw "Not connected to vCenter Server '$Server'. Please use Connect-AnyStackServer first."
        }
        return $vi
    }

    throw "Invalid Server parameter. Must be a string or VIServer object."
}

 

