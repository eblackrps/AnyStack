function Get-AnyStackOrphanedState {
    <#
    .SYNOPSIS
        Finds orphaned VMs.
    .DESCRIPTION
        Checks Runtime.ConnectionState.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackOrphanedState
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
        $Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finding orphaned VMs on $($vi.Name)"
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Property Name,Runtime.ConnectionState,Config.DatastoreUrl }
            
            $orphans = $vms | Where-Object { $_.Runtime.ConnectionState -eq 'orphaned' }
            
            foreach ($vm in $orphans) {
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.OrphanedVm'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    VmName          = $vm.Name
                    DatastorePath   = $vm.Config.DatastoreUrl[0].Url
                    ConnectionState = $vm.Runtime.ConnectionState
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



