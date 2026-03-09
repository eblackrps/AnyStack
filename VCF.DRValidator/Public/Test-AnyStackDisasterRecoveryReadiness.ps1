function Test-AnyStackDisasterRecoveryReadiness {
    <#
    .SYNOPSIS
        Tests disaster recovery readiness.
    .DESCRIPTION
        Checks VM snapshot age, HA, and network.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Test-AnyStackDisasterRecoveryReadiness
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
        [string]$ClusterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing DR readiness on $($vi.Name)"
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Property Name,Snapshot,Guest }
            
            foreach ($vm in $vms) {
                $snapAge = 0
                if ($vm.Snapshot -and $vm.Snapshot.RootSnapshotList) {
                    $oldestSnap = Get-OldSnapshot -SnapshotTree $vm.Snapshot.RootSnapshotList
                    if ($oldestSnap) {
                        $snapAge = [Math]::Round(((Get-Date) - $oldestSnap.CreateTime).TotalHours, 1)
                    }
                }

                $haEnabled = $false
                try {
                    $hostView = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vm.Runtime.Host -Property Parent }
                    $parentView = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $hostView.Parent -Property Configuration }
                    if ($parentView -and $parentView.Configuration -and $parentView.Configuration.DasConfig) {
                        $haEnabled = $parentView.Configuration.DasConfig.Enabled
                    }
                } catch {
                    $haEnabled = $false
                }

                $reachable = $false
                if ($vm.Guest.IpAddress) {
                    $ip = $vm.Guest.IpAddress
                    $ping = Test-NetConnection -ComputerName $ip -Port 443 -InformationLevel Quiet -ErrorAction SilentlyContinue
                    $reachable = $ping
                }

                [PSCustomObject]@{
                    PSTypeName       = 'AnyStack.DRReadiness'
                    Timestamp        = (Get-Date)
                    Server           = $vi.Name
                    VmName           = $vm.Name
                    SnapshotAge      = $snapAge
                    HaEnabled        = $haEnabled
                    NetworkReachable = $reachable
                    OverallReady     = ($snapAge -lt 72 -and $reachable)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


