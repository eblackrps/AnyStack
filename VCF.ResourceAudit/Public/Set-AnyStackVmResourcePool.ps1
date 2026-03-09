function Set-AnyStackVmResourcePool {
    <#
    .SYNOPSIS
        Moves VM to a resource pool.
    .DESCRIPTION
        Calls MoveIntoResourcePool.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Name of the virtual machine.
    .PARAMETER ResourcePoolName
        Name of the target resource pool.
    .EXAMPLE
        PS> Set-AnyStackVmResourcePool -VmName 'DB-01' -ResourcePoolName 'HighPriority'
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
        [Parameter(Mandatory=$true)]
        [string]$VmName,
        [Parameter(Mandatory=$true)]
        [string]$ResourcePoolName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($VmName, "Move to Resource Pool $ResourcePoolName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Moving VM to resource pool on $($vi.Name)"
                $vm = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter @{Name=$VmName} }
                $prevPool = Invoke-AnyStackWithRetry -ScriptBlock { (Get-View -Server $vi -Id $vm.ResourcePool).Name }
                $rp = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ResourcePool -Filter @{Name=$ResourcePoolName} }
                
                Invoke-AnyStackWithRetry -ScriptBlock { $rp.MoveIntoResourcePool(@($vm.MoRef)) }
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.VmResourcePool'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    VmName       = $VmName
                    PreviousPool = $prevPool
                    NewPool      = $ResourcePoolName
                    Applied      = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



