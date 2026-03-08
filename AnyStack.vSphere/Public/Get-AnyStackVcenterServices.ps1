function Get-AnyStackVcenterService {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Lists core vCenter services and their status.
    .DESCRIPTION
        Round 9: Core Framework Enhancement. Standardizes console output,
        JSON logging, and transcript management across the suite.
    .INPUTS
        VMware.VimAutomation.Types.VIServer. Accepts a connected VIServer object via pipeline.
    .OUTPUTS
        PSCustomObject. Returns a result object with Timestamp, Status, and relevant data fields.
    .LINK
        https://github.com/eblackrps/AnyStack
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        [VMware.VimAutomation.Types.VIServer]$Server
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            $serviceInstance = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $Server -Id 'ServiceInstance' -Property Content.ServiceManager }
            $serviceManager = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $Server -Id $serviceInstance.Content.ServiceManager -Property Service }

            foreach ($s in $serviceManager.Service) {
                [PSCustomObject]@{
                    Timestamp   = (Get-Date)
                    Status      = 'Success'
                    ServiceName = $s.ServiceName
                    Running     = $s.Running
                }
            }
        }
        catch {
            Write-Error "Failed to get vCenter services: $($_.Exception.Message)" -Category InvalidOperation
        }
    }
}
