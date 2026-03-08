function Set-AnyStackDrsRule {
    <#
    .SYNOPSIS
        Sets a DRS affinity or anti-affinity rule.
    .DESCRIPTION
        Creates or updates a cluster VM rule.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Name of the cluster.
    .PARAMETER RuleName
        Name of the rule.
    .PARAMETER RuleType
        Affinity or AntiAffinity.
    .PARAMETER VmNames
        List of VM names in the rule.
    .PARAMETER Enabled
        Whether the rule is enabled.
    .EXAMPLE
        PS> Set-AnyStackDrsRule -ClusterName 'C1' -RuleName 'Sep-VMs' -RuleType AntiAffinity -VmNames 'V1','V2'
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
        [string]$ClusterName,
        [Parameter(Mandatory=$true)]
        [string]$RuleName,
        [Parameter(Mandatory=$true)]
        [ValidateSet('Affinity','AntiAffinity')]
        [string]$RuleType,
        [Parameter(Mandatory=$true)]
        [string[]]$VmNames,
        [Parameter(Mandatory=$false)]
        [bool]$Enabled = $true
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($ClusterName, "Set DRS Rule $RuleName")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Setting DRS rule on $($vi.Name)"
                $cluster = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType ClusterComputeResource -Filter @{Name=$ClusterName} }
                $vms = Invoke-AnyStackWithRetry -ScriptBlock {
                    $VmNames | ForEach-Object { (Get-View -Server $vi -ViewType VirtualMachine -Filter @{Name=$_}).MoRef }
                }
                
                $spec = New-Object VMware.Vim.ClusterConfigSpecEx
                $ruleSpec = New-Object VMware.Vim.ClusterRuleSpec
                $ruleSpec.Operation = 'add'
                
                $rule = if ($RuleType -eq 'Affinity') { New-Object VMware.Vim.ClusterAffinityRuleSpec }
                        else { New-Object VMware.Vim.ClusterAntiAffinityRuleSpec }
                
                $rule.Name = $RuleName
                $rule.Enabled = $Enabled
                $rule.Vm = $vms
                $ruleSpec.Info = $rule
                $spec.RulesSpec = @($ruleSpec)
                
                Invoke-AnyStackWithRetry -ScriptBlock { $cluster.ReconfigureComputeResource_Task($spec, $true) }
                
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.DrsRule'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    RuleName   = $RuleName
                    RuleType   = $RuleType
                    VmsInRule  = $VmNames.Count
                    Enabled    = $Enabled
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 
