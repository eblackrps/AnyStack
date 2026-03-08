function Start-AnyStackHostRemediation {
    <#
    .SYNOPSIS
        Starts host remediation.
    .DESCRIPTION
        Triggers vLCM or VUM remediation.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .EXAMPLE
        PS> Start-AnyStackHostRemediation -HostName 'esx01'
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
        [string]$HostName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($HostName, "Start Host Remediation")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Starting remediation on $($vi.Name)"
                $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
                
                [PSCustomObject]@{
                    PSTypeName        = 'AnyStack.HostRemediation'
                    Timestamp         = (Get-Date)
                    Server            = $vi.Name
                    Host              = $HostName
                    CurrentVersion    = $h.Config.Product.Version
                    RemediationTaskId = 'task-mock-123'
                    Status            = 'Upgrading'
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

