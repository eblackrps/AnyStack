function Get-AnyStackVmMigrationHistory {
    <#
    .SYNOPSIS
        Gets VM vMotion history.
    .DESCRIPTION
        Queries the EventManager.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER VmName
        Filter by VM.
    .PARAMETER MaxEvents
        Number of events to retrieve (default 10).
    .EXAMPLE
        PS> Get-AnyStackVmMigrationHistory -VmName 'DB-01'
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
        [string]$VmName,
        [Parameter(Mandatory=$false)]
        [int]$MaxEvents = 10
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Querying migration history on $($vi.Name)"
            $filter = if ($VmName) { @{Name="*$VmName*"} } else { $null }
            $vms = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType VirtualMachine -Filter $filter -Property Name }
            
            $eventMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.EventManager }
            
            foreach ($vm in $vms) {
                $evFilter = New-Object VMware.Vim.EventFilterSpec
                $evFilter.Entity = New-Object VMware.Vim.EventFilterSpecByEntity
                $evFilter.Entity.Entity = $vm.MoRef
                $evFilter.EventTypeId = @('VmMigratedEvent','VmBeingMigratedEvent')
                
                $events = Invoke-AnyStackWithRetry -ScriptBlock { $eventMgr.QueryEvents($evFilter) | Select-Object -Last $MaxEvents }
                
                foreach ($e in $events) {
                    [PSCustomObject]@{
                        PSTypeName = 'AnyStack.VmMigration'
                        Timestamp  = (Get-Date)
                        Server     = $vi.Name
                        VmName     = $vm.Name
                        MigratedAt = $e.CreatedTime
                        SourceHost = $e.SourceHost.Name
                        DestHost   = $e.Host.Name
                        Initiator  = $e.UserName
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
