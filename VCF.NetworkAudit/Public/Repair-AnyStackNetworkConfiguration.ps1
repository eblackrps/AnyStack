function Repair-AnyStackNetworkConfiguration {
    <#
    .SYNOPSIS
        Remediates network configuration drift.
    .DESCRIPTION
        Round 5: VCF.NetworkAudit Extension. Disables Promiscuous mode automatically.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)] $Server,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [psobject[]]$AuditResult
    )
    process {
        $ErrorActionPreference = 'Stop'
        foreach ($res in $AuditResult) {
            if ($res.PromiscuousMode -eq $true -and $res.SwitchType -eq "DVPortgroup") {
                if ($PSCmdlet.ShouldProcess($res.SwitchName, "Disable Promiscuous Mode")) {
                    Write-Host "[REPAIR] Calling ReconfigureDVPortgroup_Task for $($res.SwitchName)" -ForegroundColor Green
                    try {
                        $dvpgView = Get-View -Server $Server -ViewType DistributedVirtualPortgroup -Filter @{"Name"="^$($res.SwitchName)$"} -ErrorAction Stop
                        if ($dvpgView) {
                            $spec = New-Object VMware.Vim.DVPortgroupConfigSpec
                            $spec.ConfigVersion = $dvpgView.Config.ConfigVersion
                            $spec.DefaultPortConfig = New-Object VMware.Vim.VMwareDVSPortSetting
                            $spec.DefaultPortConfig.SecurityPolicy = New-Object VMware.Vim.DVSSecurityPolicy
                            $spec.DefaultPortConfig.SecurityPolicy.AllowPromiscuous = New-Object VMware.Vim.BoolPolicy
                            $spec.DefaultPortConfig.SecurityPolicy.AllowPromiscuous.Inherited = $false
                            $spec.DefaultPortConfig.SecurityPolicy.AllowPromiscuous.Value = $false
                            
                            $taskRef = $dvpgView.ReconfigureDVPortgroup_Task($spec)
                            Write-Verbose "Reconfiguration Task initiated: $($taskRef.Value)"
                        } else {
                            Write-Warning "DVPortgroup $($res.SwitchName) not found."
                        }
                    } catch {
                        Write-Error "Failed to repair DVPortgroup $($res.SwitchName): $($_.Exception.Message)"
                    }
                }
            }
        }
    }
}
