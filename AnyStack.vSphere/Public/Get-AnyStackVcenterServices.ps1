function Get-AnyStackVcenterServices {
    <#
    .SYNOPSIS
        Lists vCenter services and their status.
    .DESCRIPTION
        Queries ServiceManager for all registered vCenter services.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackVcenterServices
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching vCenter services on $($vi.Name)"
            $serviceInstance = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id 'ServiceInstance' -Property Content.ServiceManager }
            $serviceManager = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $serviceInstance.Content.ServiceManager -Property Service }

            foreach ($s in $serviceManager.Service) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.VcenterService'
                    Timestamp   = (Get-Date)
                    Status      = 'Success'
                    Server      = $vi.Name
                    ServiceName = $s.ServiceName
                    Running     = $s.Running
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
