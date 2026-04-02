function Restart-AnyStackVmTools {
    <#
    .SYNOPSIS
        Restarts VM Tools inside the guest OS.
    .DESCRIPTION
        Calls RestartGuest.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Filter by VM name.
    .PARAMETER ClusterName
        Filter by cluster.
    .EXAMPLE
        PS> Restart-AnyStackVmTools -VmName 'DB-01'
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Restarting VM tools on $($vi.Name)"
            $vms = Get-AnyStackVirtualMachineView -Server $vi -ClusterName $ClusterName -VmName $VmName -Property @('Name','Guest.ToolsRunningStatus','Guest.ToolsVersion')
            
            foreach ($vm in $vms) {
                if ($vm.Guest.ToolsRunningStatus -eq 'guestToolsRunning') {
                    if ($PSCmdlet.ShouldProcess($vm.Name, "Restart Guest OS via Tools")) {
                        Invoke-AnyStackWithRetry -ScriptBlock { $vm.RestartGuest() }
                        
                        [PSCustomObject]@{
                            PSTypeName       = 'AnyStack.VmToolsRestart'
                            Timestamp        = (Get-Date)
                            Server           = $vi.Name
                            VmName           = $vm.Name
                            ToolsVersion     = $vm.Guest.ToolsVersion
                            ToolsStatus      = $vm.Guest.ToolsRunningStatus
                            RestartInitiated = $true
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
