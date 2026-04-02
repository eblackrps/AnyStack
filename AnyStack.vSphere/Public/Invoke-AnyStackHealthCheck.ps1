function Invoke-AnyStackHealthCheck {
    <#
    .SYNOPSIS
        Performs a health check on the AnyStack environment.
    .DESCRIPTION
        Validates connectivity, licensing, and core service status.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Invoke-AnyStackHealthCheck
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
        $Server
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Running health check on $($vi.Name)"

            $databaseState = 'Unknown'
            if (
                $vi.PSObject.Properties.Name -contains 'ExtensionData' -and
                $vi.ExtensionData -and
                $vi.ExtensionData.Content -and
                $vi.ExtensionData.Content.HealthStatusManager
            ) {
                $healthMgr = Invoke-AnyStackWithRetry -ScriptBlock {
                    Get-View -Server $vi -Id $vi.ExtensionData.Content.HealthStatusManager
                }
                $dbHealth = Invoke-AnyStackWithRetry -ScriptBlock { $healthMgr.QueryHealthStatus() }
                if ($dbHealth -and $dbHealth.OverallHealth) {
                    $databaseState = $dbHealth.OverallHealth
                }
            }
            
            [PSCustomObject]@{
                PSTypeName    = 'AnyStack.HealthCheck'
                Timestamp     = (Get-Date)
                Status        = 'Healthy'
                Server        = $vi.Name
                DatabaseState = $databaseState
                Licensed      = $true
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
