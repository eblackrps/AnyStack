function Get-OldSnapshot {
    <#
    .SYNOPSIS
        Internal helper to recursively find the oldest snapshot.
    #>
    param($SnapshotTree)
    $oldest = $null
    foreach ($snap in $SnapshotTree) {
        if (-not $oldest -or $snap.CreateTime -lt $oldest.CreateTime) { $oldest = $snap }
        if ($snap.ChildSnapshotList) {
            $childOldest = Get-OldSnapshot -SnapshotTree $snap.ChildSnapshotList
            if ($childOldest -and (-not $oldest -or $childOldest.CreateTime -lt $oldest.CreateTime)) {
                $oldest = $childOldest
            }
        }
    }
    return $oldest
}
 
