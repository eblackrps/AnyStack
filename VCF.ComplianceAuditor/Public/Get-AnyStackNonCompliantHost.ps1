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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching non-compliant hosts on $($vi.Name)"
            $hpMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.HostProfileManager }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Property Name,Config }
            
            $taskRef = Invoke-AnyStackWithRetry -ScriptBlock { $hpMgr.CheckCompliance_Task($hosts.MoRef) }
            $task = Get-Task -Id $taskRef.Value -Server $vi
            $task | Wait-Task -ErrorAction Stop | Out-Null
            
            $results = Invoke-AnyStackWithRetry -ScriptBlock { (Get-View -Server $vi -Id $taskRef).Info.Result }
            
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
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



