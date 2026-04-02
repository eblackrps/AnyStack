function Set-AnyStackVmAffinityRule {
    <#
    .SYNOPSIS
        Sets VM-Host affinity rule.
    .DESCRIPTION
        Creates a VM-Host affinity rule.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Name of the cluster.
    .PARAMETER RuleName
        Name of the rule.
    .PARAMETER VmNames
        VMs to include.
    .PARAMETER HostGroupName
        Target host group.
    .PARAMETER Mandatory
        Whether rule is mandatory.
    .EXAMPLE
        PS> Set-AnyStackVmAffinityRule -ClusterName C1 -RuleName R1 -VmNames V1 -HostGroupName G1
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
        [string]$RuleName,
        [Parameter(Mandatory=$true)]
        [string[]]$VmNames,
        [Parameter(Mandatory=$true)]
        [string]$HostGroupName,
        [Parameter(Mandatory=$false)]
        [bool]$Mandatory = $false
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($ClusterName, "Set VM-Host Affinity $RuleName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Setting VM affinity on $($vi.Name)"
                $cluster = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter @{Name=$ClusterName} }
                
                Invoke-AnyStackWithRetry -ScriptBlock {
                    if ($cluster) {
                        $spec = New-Object VMware.Vim.ClusterConfigSpecEx
                        $ruleSpec = New-Object VMware.Vim.ClusterRuleSpec
                        $ruleSpec.Operation = 'add'
                        $rule = New-Object VMware.Vim.ClusterVmHostRuleInfo
                        $rule.Name = $RuleName
                        $rule.Mandatory = $Mandatory
                        $rule.AffineHostGroupName = $HostGroupName
                        $ruleSpec.Info = $rule
                        $spec.RulesSpec = @($ruleSpec)
                        $cluster.ReconfigureComputeResource_Task($spec, $true)
                    }
                }
                
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.VmAffinityRule'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    RuleName    = $RuleName
                    RuleType    = 'VmHost'
                    Mandatory   = $Mandatory
                    VmsAffected = $VmNames.Count
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
