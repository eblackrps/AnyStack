function Get-AnyStackClusterImage {
    <#
    .SYNOPSIS
        Retrieves vLCM cluster image info.
    .DESCRIPTION
        Checks if a cluster is vLCM managed and gets the base image version.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Get-AnyStackClusterImage
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
        [string]$ClusterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching cluster images on $($vi.Name)"
            $filter = if ($ClusterName) { @{Name="*$ClusterName*"} } else { $null }
            $clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter $filter -Property Name,ConfigurationEx }
            
            foreach ($c in $clusters) {
                $vlcmManaged = ($null -ne $c.ConfigurationEx.DesiredSoftwareSpec)
                $version = if ($vlcmManaged) { $c.ConfigurationEx.DesiredSoftwareSpec.BaseImageSpec.Version } else { 'N/A' }
                
                [PSCustomObject]@{
                    PSTypeName       = 'AnyStack.ClusterImage'
                    Timestamp        = (Get-Date)
                    Server           = $vi.Name
                    Cluster          = $c.Name
                    VlcmManaged      = $vlcmManaged
                    BaseImageVersion = $version
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $vi.Name))
        }
    }
}
