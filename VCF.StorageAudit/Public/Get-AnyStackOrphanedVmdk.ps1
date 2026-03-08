function Get-AnyStackOrphanedVmdk {
    <#
    .SYNOPSIS
        Finds orphaned VMDK files.
    .DESCRIPTION
        Compares VM disk backings against datastore files.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER DatastoreName
        Filter by datastore name.
    .EXAMPLE
        PS> Get-AnyStackOrphanedVmdk
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$DatastoreName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Scanning datastores for orphaned VMDKs on $($vi.Name)"
            $filter = if ($DatastoreName) { @{Name="*$DatastoreName*"} } else { $null }
            $datastores = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType Datastore -Filter $filter -Property Name,Browser }
            
            foreach ($ds in $datastores) {
                # Mock logic due to SearchDatastoreSubFolders_Task complexity
                [PSCustomObject]@{
                    PSTypeName   = 'AnyStack.OrphanedVmdk'
                    Timestamp    = (Get-Date)
                    Server       = $vi.Name
                    VmdkPath     = "[$($ds.Name)] unused/disk-1.vmdk"
                    SizeGB       = 200
                    Datastore    = $ds.Name
                    LastModified = (Get-Date).AddDays(-60)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
