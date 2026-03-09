function Invoke-AnyStackDatastoreUnmount {
    <#
    .SYNOPSIS
        Unmounts a datastore.
    .DESCRIPTION
        Calls DatastoreSystem RemoveDatastore.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER DatastoreName
        Name of the datastore.
    .PARAMETER HostName
        Name of the host.
    .EXAMPLE
        PS> Invoke-AnyStackDatastoreUnmount -DatastoreName 'DS1' -HostName 'esx01'
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
        [string]$DatastoreName,
        [Parameter(Mandatory=$true)]
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($DatastoreName, "Unmount on host $HostName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Unmounting datastore on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                $ds = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType Datastore -Filter @{Name=$DatastoreName} }
                $dsSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.DatastoreSystem }
                
                Invoke-AnyStackWithRetry -ScriptBlock { $dsSystem.RemoveDatastore($ds.MoRef) }
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.DatastoreUnmount'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    Datastore  = $DatastoreName
                    Host       = $HostName
                    MountState = 'Unmounted'
                    Applied    = $true
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
