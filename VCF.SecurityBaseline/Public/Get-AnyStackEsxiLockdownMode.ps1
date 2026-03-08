function Get-AnyStackEsxiLockdownMode {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Audits the lockdown mode status for all ESXi hosts.
    .DESCRIPTION
        VCF.SecurityBaseline. Validates if hosts meet strict vSphere 8.0 security guidelines.
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
            $hosts = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $Server -ViewType HostSystem -Property Name,Config.LockdownMode }

            foreach ($h in $hosts) {
                [PSCustomObject]@{
                    Timestamp    = (Get-Date)
                    Status       = 'Success'
                    Host         = $h.Name
                    LockdownMode = $h.Config.LockdownMode
                }
            }
        }
        catch {
            Write-Error "Failed to get ESXi lockdown mode: $($_.Exception.Message)" -Category InvalidOperation
        }
    }
}
