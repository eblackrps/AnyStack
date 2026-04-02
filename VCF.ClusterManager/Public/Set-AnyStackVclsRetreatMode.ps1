function Set-AnyStackVclsRetreatMode {
    <#
    .SYNOPSIS
        Toggles vCLS retreat mode for a cluster.
    .DESCRIPTION
        Updates config.vcls.clusters.<id>.enabled.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Name of the cluster.
    .PARAMETER Enabled
        True to enable retreat mode (disables vCLS).
    .EXAMPLE
        PS> Set-AnyStackVclsRetreatMode -ClusterName 'C1' -Enabled $true
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
        [string]$ClusterName,
        [Parameter(Mandatory=$true)]
        [bool]$Enabled
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($ClusterName, "Set vCLS Retreat Mode = $Enabled")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Setting vCLS retreat mode on $($vi.Name)"
                $cluster = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter @{Name=$ClusterName} }
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.Setting }
                
                $valStr = if ($Enabled) { "false" } else { "true" } # retreat enabled means vcls disabled
                $key = "config.vcls.clusters.$($cluster.MoRef.Value).enabled"
                
                Invoke-AnyStackWithRetry -ScriptBlock { 
                    $optMgr.UpdateValues(@([VMware.Vim.OptionValue]@{Key=$key; Value=$valStr}))
                }
                
                [PSCustomObject]@{
                    PSTypeName         = 'AnyStack.VclsRetreatMode'
                    Timestamp          = (Get-Date)
                    Server             = $vi.Name
                    Cluster            = $ClusterName
                    RetreatModeEnabled = $Enabled
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
