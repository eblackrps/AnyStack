function Optimize-AnyStackSnapshots {
    <#
    .SYNOPSIS
        Optimizes snapshots via consolidation.
    .DESCRIPTION
        Calls ConsolidateVMDisks_Task on VMs needing it.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Filter by VM name.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Optimize-AnyStackSnapshots
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$VmName,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Optimizing snapshots on $($vi.Name)"
            $filter = if ($VmName) { @{Name="*$VmName*"} } else { $null }
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter $filter -Property Name,Runtime.ConsolidationNeeded }
            
            foreach ($vm in $vms) {
                if ($vm.Runtime.ConsolidationNeeded -eq $true) {
                    if ($PSCmdlet.ShouldProcess($vm.Name, "Consolidate VM Disks")) {
                        $taskRef = Invoke-AnyStackWithRetry -ScriptBlock { $vm.ConsolidateVMDisks_Task() }
                        
                        [PSCustomObject]@{
                            PSTypeName         = 'AnyStack.OptimizedSnapshot'
                            Timestamp          = (Get-Date)
                            Server             = $vi.Name
                            VmName             = $vm.Name
                            NeedsConsolidation = $true
                            TaskId             = $taskRef.Value
                            Status             = 'Consolidating'
                        }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
