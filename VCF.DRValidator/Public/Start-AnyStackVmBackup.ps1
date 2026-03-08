function Start-AnyStackVmBackup {
    <#
    .SYNOPSIS
        Starts a VM backup.
    .DESCRIPTION
        Creates a snapshot for backup.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Name of the virtual machine.
    .PARAMETER SnapshotName
        Name of the snapshot.
    .EXAMPLE
        PS> Start-AnyStackVmBackup -VmName 'DB-01'
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
        [Parameter(Mandatory=$false)]
        [string]$SnapshotName = "AnyStack-Backup-$(Get-Date -f yyyyMMdd-HHmm)"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($VmName, "Create backup snapshot $SnapshotName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Creating backup snapshot on $($vi.Name)"
                $vm = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter @{Name=$VmName} }
                $task = Invoke-AnyStackWithRetry -ScriptBlock { $vm.CreateSnapshot_Task($SnapshotName, 'AnyStack automated backup', $false, $false) }
                
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.VmBackup'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    VmName       = $VmName
                    SnapshotName = $SnapshotName
                    BackupJobId  = $task.Value
                    Status       = 'Created'
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

