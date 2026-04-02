function Update-AnyStackVmHardware {
    <#
    .SYNOPSIS
        Upgrades VM hardware compatibility.
    .DESCRIPTION
        Calls UpgradeVM_Task.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Filter by VM name.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Update-AnyStackVmHardware -VmName 'DB-01'
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Upgrading VM hardware on $($vi.Name)"
            $vms = Get-AnyStackVirtualMachineView -Server $vi -ClusterName $ClusterName -VmName $VmName -Property @('Name','Config.Version','Runtime.PowerState')
            
            foreach ($vm in $vms) {
                if ($vm.Runtime.PowerState -eq 'poweredOff') {
                    if ($PSCmdlet.ShouldProcess($vm.Name, "Upgrade VM Hardware")) {
                        $taskRef = Invoke-AnyStackWithRetry -ScriptBlock { $vm.UpgradeVM_Task($null) }
                        
                        [PSCustomObject]@{
                            PSTypeName     = 'AnyStack.VmHardwareUpgrade'
                            Timestamp      = (Get-Date)
                            Server         = $vi.Name
                            VmName         = $vm.Name
                            CurrentVersion = $vm.Config.Version
                            TargetVersion  = 'latest'
                            TaskId         = $taskRef.Value
                            Status         = 'Upgrading'
                        }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
