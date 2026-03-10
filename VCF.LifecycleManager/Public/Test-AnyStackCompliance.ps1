function Test-AnyStackCompliance {
    <#
    .SYNOPSIS
        Tests host compliance against Host Profiles.
    .DESCRIPTION
        Invokes CheckCompliance_Task.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Test-AnyStackCompliance
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
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Testing compliance on $($vi.Name)"
            $hpMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.HostProfileManager }
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Property Name }
            
            $taskRef = if ($hpMgr) { Invoke-AnyStackWithRetry -ScriptBlock { $hpMgr.CheckCompliance_Task($hosts.MoRef) } } else { $null }
            if ($taskRef) {
                $task = Get-Task -Id $taskRef.Value -Server $vi
                $task | Wait-Task -ErrorAction SilentlyContinue | Out-Null
            }
            $results = if ($taskRef) { Invoke-AnyStackWithRetry -ScriptBlock { (Get-View -Server $vi -Id $taskRef).Info.Result } } else { @() }
            
            foreach ($res in $results) {
                if ($res) {
                    $h = $hosts | Where-Object { $_.MoRef.Value -eq $res.Entity.Value }
                    [PSCustomObject]@{
                        PSTypeName           = 'AnyStack.HostCompliance'
                        Timestamp            = (Get-Date)
                        Server               = $vi.Name
                        Host                 = $h.Name
                        BaselineProfile      = 'Unknown'
                        CompliantSettings    = 0
                        NonCompliantSettings = if ($res.Failure) { $res.Failure.Count } else { 0 }
                        ComplianceStatus     = $res.ComplianceStatus
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
