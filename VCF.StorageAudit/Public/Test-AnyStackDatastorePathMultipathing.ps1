function Test-AnyStackDatastorePathMultipathing {
    <#
    .SYNOPSIS
        Tests multipathing status.
    .DESCRIPTION
        Checks StorageDeviceInfo.MultipathInfo for compliant paths.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Test-AnyStackDatastorePathMultipathing
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
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing multipathing on $($vi.Name)"
            $filter = if ($HostName) { @{Name="*$HostName*"} } else { $null }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter $filter -Property Name,ConfigManager }
            
            foreach ($h in $hosts) {
                $storageSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.StorageSystem }
                $luns = $storageSystem.StorageDeviceInfo.MultipathInfo.Lun
                
                foreach ($lun in $luns) {
                    $activeCount = ($lun.Path | Where-Object { $_.State -eq 'active' }).Count
                    [PSCustomObject]@{
                        PSTypeName  = 'AnyStack.Multipathing'
                        Timestamp   = (Get-Date)
                        Server      = $vi.Name
                        Host        = $h.Name
                        Device      = $lun.Id
                        Policy      = $lun.PathSelectionPolicy.Policy
                        TotalPaths  = $lun.Path.Count
                        ActivePaths = $activeCount
                        Compliant   = ($activeCount -ge 2)
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


