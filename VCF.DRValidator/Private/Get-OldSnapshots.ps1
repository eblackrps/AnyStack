function Get-OldSnapshot {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Internal helper to recursively find snapshots older than a specified threshold.
    #>
    param($SnapshotTree, [datetime]$OlderThan)
    foreach ($snap in $SnapshotTree) {
        if ($snap.CreateTime -lt $OlderThan) { return $true }
        if ($snap.ChildSnapshotList) {
            if (Get-OldSnapshots -SnapshotTree $snap.ChildSnapshotList -OlderThan $OlderThan) { return $true }
        }
    }
    return $false
}
