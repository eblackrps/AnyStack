function Repair-AnyStackComplianceDrift {
    <#
    .SYNOPSIS
        Repairs compliance drift based on audit.
    .DESCRIPTION
        Fixes non-compliant settings (e.g. stops SSH).
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .PARAMETER HostName
        Filter by host name.
    .EXAMPLE
        PS> Repair-AnyStackComplianceDrift -HostName 'esx01'
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
        [Parameter(Mandatory=$false)]
        [string]$ClusterName,
        [Parameter(Mandatory=$false)]
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Repairing compliance drift on $($vi.Name)"
            $audits = Invoke-AnyStackWithRetry -ScriptBlock { Invoke-AnyStackCisStigAudit -Server $vi -ClusterName $ClusterName -HostName $HostName -ErrorAction SilentlyContinue }
            
            foreach ($audit in $audits) {
                if ($audit.FindingsCount -gt 0) {
                    $applied = 0
                    if ($PSCmdlet.ShouldProcess($audit.Host, "Repair compliance drift")) {
                        $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$audit.Host} }
                        
                        foreach ($f in $audit.Findings) {
                            if (-not $f.Passed) {
                                if ($f.CheckId -eq 'SSH-001') {
                                    $svcSystem = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $h.ConfigManager.ServiceSystem }
                                    Invoke-AnyStackWithRetry -ScriptBlock { $svcSystem.StopService('TSM-SSH') }
                                    $applied++
                                }
                            }
                        }
                    }
                    [PSCustomObject]@{
                        PSTypeName          = 'AnyStack.ComplianceRepair'
                        Timestamp           = (Get-Date)
                        Server              = $vi.Name
                        Host                = $audit.Host
                        RemediationsApplied = $applied
                        RemediationsFailed  = 0
                        SkippedManual       = $audit.FindingsCount - $applied
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



