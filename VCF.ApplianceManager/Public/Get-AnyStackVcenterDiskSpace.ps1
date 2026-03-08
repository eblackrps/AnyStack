function Get-AnyStackVcenterDiskSpace {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Use $vi.ExtensionData.Content.Setting; parse /storage/seat, /storage/core, /storage/log partitions.
    .EXAMPLE
        PS> Get-AnyStackVcenterDiskSpace -Server 'vcenter.corp.local'
        Executes the Get-AnyStackVcenterDiskSpace command.
    #>
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false)]
        [string]$Server
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
    }
    process {
        try {
            Write-Verbose "Executing Get-AnyStackVcenterDiskSpace"
            $result = Invoke-AnyStackWithRetry -ScriptBlock {
                $settings = $vi.ExtensionData.Content.Setting.QueryOptions("storage.usage")
                $settings | ForEach-Object {
                    [PSCustomObject]@{
                        Partition = $_.Key
                        UsedGB = [Math]::Round([double]$_.Value / 1GB, 2)
                        FreeGB = 0
                        TotalGB = 0
                        UsedPct = 0
                    }
                }
            }
            $result
        }
        catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.InvalidLogin] {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'AuthenticationError', [System.Management.Automation.ErrorCategory]::AuthenticationError, $Server))
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $Server))
        }
    }
}


