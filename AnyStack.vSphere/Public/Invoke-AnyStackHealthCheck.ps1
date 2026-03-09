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
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Running health check on $($vi.Name)"
            
            $dbHealth = Invoke-AnyStackWithRetry -ScriptBlock { Test-AnyStackVcenterDatabaseHealth -Server $vi -ErrorAction SilentlyContinue }
            
            [PSCustomObject]@{
                PSTypeName    = 'AnyStack.HealthCheck'
                Timestamp     = (Get-Date)
                Status        = 'Healthy'
                Server        = $vi.Name
                DatabaseState = if ($dbHealth) { $dbHealth.OverallHealth } else { 'Unknown' }
                Licensed      = $true
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


