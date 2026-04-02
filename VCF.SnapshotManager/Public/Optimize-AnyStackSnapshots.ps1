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
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
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
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Optimizing snapshots on $($vi.Name)"
            $vms = Get-AnyStackVirtualMachineView -Server $vi -ClusterName $ClusterName -VmName $VmName -Property @('Name','Runtime.ConsolidationNeeded')
            
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
