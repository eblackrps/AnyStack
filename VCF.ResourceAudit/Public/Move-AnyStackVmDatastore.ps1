function Move-AnyStackVmDatastore {
    <#
    .SYNOPSIS
        Moves VM to another datastore.
    .DESCRIPTION
        Initiates Storage vMotion via RelocateVM_Task.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Name of the virtual machine.
    .PARAMETER DestinationDatastore
        Name of the target datastore.
    .EXAMPLE
        PS> Move-AnyStackVmDatastore -VmName 'DB-01' -DestinationDatastore 'vsanDatastore'
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
        [Parameter(Mandatory=$true)]
        [string]$VmName,
        [Parameter(Mandatory=$true)]
        [string]$DestinationDatastore
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($VmName, "Move to datastore $DestinationDatastore")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Initiating storage vMotion on $($vi.Name)"
                $vm = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter @{Name=$VmName} }
                $ds = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType Datastore -Filter @{Name=$DestinationDatastore} }
                
                $spec = New-Object VMware.Vim.VirtualMachineRelocateSpec
                $spec.Datastore = $ds.MoRef
                
                $taskRef = Invoke-AnyStackWithRetry -ScriptBlock { $vm.RelocateVM_Task($spec, 'defaultPriority') }
                
                [PSCustomObject]@{
                    PSTypeName      = 'AnyStack.VmDatastoreMove'
                    Timestamp       = (Get-Date)
                    Server          = $vi.Name
                    VmName          = $VmName
                    SourceDatastore = $vm.Config.DatastoreUrl[0].Name
                    DestDatastore   = $DestinationDatastore
                    TaskId          = $taskRef.Value
                    Status          = 'Running'
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

