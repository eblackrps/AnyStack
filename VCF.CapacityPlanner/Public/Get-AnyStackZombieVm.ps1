function Get-AnyStackZombieVm {
    <#
    .SYNOPSIS
        Identifies zombie VMs.
    .DESCRIPTION
        Finds VMs powered off for more than AgeDays.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER AgeDays
        Number of days powered off (default 90).
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Get-AnyStackZombieVm -AgeDays 90
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
        [int]$AgeDays = 90,
        [Parameter(Mandatory=$false)]
        [string]$ClusterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finding zombie VMs on $($vi.Name)"
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { 
                Get-View -Server $vi -ViewType VirtualMachine -Property Name,Runtime.PowerState,Config.Modified,Summary.Storage.Committed
            }
            
            $threshold = (Get-Date).AddDays(-$AgeDays)
            $zombies = $vms | Where-Object { $_.Runtime.PowerState -eq 'poweredOff' -and $_.Config.Modified -lt $threshold }
            
            foreach ($vm in $zombies) {
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.ZombieVm'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    VmName       = $vm.Name
                    PowerState   = $vm.Runtime.PowerState
                    LastModified = $vm.Config.Modified
                    SizeGB       = [Math]::Round($vm.Summary.Storage.Committed / 1GB, 2)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


