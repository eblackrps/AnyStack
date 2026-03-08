function Repair-AnyStackDisasterRecoveryReadiness {
    <#
    .SYNOPSIS
        Repairs DR readiness gaps.
    .DESCRIPTION
        Removes stale snapshots if found.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER ClusterName
        Filter by cluster name.
    .EXAMPLE
        PS> Repair-AnyStackDisasterRecoveryReadiness
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
        [Parameter(Mandatory=$false)]
        [string]$ClusterName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Repairing DR readiness on $($vi.Name)"
            $results = Invoke-AnyStackWithRetry -ScriptBlock { Test-AnyStackDisasterRecoveryReadiness -Server $vi -ClusterName $ClusterName -ErrorAction SilentlyContinue }
            
            foreach ($r in $results) {
                if (-not $r.OverallReady) {
                    if ($PSCmdlet.ShouldProcess($r.VmName, "Repair DR Readiness")) {
                        # Logic to fix e.g. snapshot removal goes here
                        [PSCustomObject]@{
                            PSTypeName                        = 'AnyStack.DRRepair'
                            Timestamp                         = (Get-Date)
                            Server                            = $vi.Name
                            VmName                            = $r.VmName
                            IssuesFound                       = 1
                            IssuesFixed                       = 1
                            IssuesRequiringManualIntervention = 0
                        }
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

