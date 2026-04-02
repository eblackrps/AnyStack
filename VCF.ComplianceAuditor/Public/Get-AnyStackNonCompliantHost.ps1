function Get-AnyStackNonCompliantHost {
    <#
    .SYNOPSIS
        Gets non-compliant hosts.
    .DESCRIPTION
        Queries HostComplianceManager for hosts not compliant.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Get-AnyStackNonCompliantHost
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
        [string]$ClusterName
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching non-compliant hosts on $($vi.Name)"
            $hpMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.HostProfileManager }
            $hosts = Get-AnyStackHostView -Server $vi -ClusterName $ClusterName -Property @('Name','Config')
            
            $taskRef = if ($hpMgr -and $hosts -and $PSCmdlet.ShouldProcess($vi.Name, 'Run host profile compliance check')) {
                Invoke-AnyStackWithRetry -ScriptBlock { $hpMgr.CheckCompliance_Task($hosts.MoRef) }
            } else { $null }
            if ($taskRef) {
                Invoke-AnyStackWithRetry -ScriptBlock {
                    Get-Task -Id $taskRef.Value -Server $vi | Wait-Task -ErrorAction SilentlyContinue | Out-Null
                } | Out-Null
            }
            $results = if ($taskRef) { Invoke-AnyStackWithRetry -ScriptBlock { (Get-View -Server $vi -Id $taskRef).Info.Result } } else { @() }
            
            foreach ($res in $results) {
                if ($res -and $res.ComplianceStatus -ne 'compliant') {
                    $h = $hosts | Where-Object { $_.MoRef.Value -eq $res.Entity.Value }
                    [PSCustomObject]@{
                        PSTypeName           = 'AnyStack.NonCompliantHost'
                        Timestamp            = (Get-Date)
                        Server               = $vi.Name
                        Host                 = $h.Name
                        BaselineProfile      = 'Unknown'
                        NonCompliantSettings = @($res.Failure | ForEach-Object { $_.Message })
                        LastChecked          = (Get-Date)
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
