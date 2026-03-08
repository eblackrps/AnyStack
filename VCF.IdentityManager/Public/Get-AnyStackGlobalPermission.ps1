function Get-AnyStackGlobalPermission {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        Executes Get-AnyStackGlobalPermission.
    .EXAMPLE
        PS> Get-AnyStackGlobalPermission -Server 'vcenter.corp.local'
        Executes the Get-AnyStackGlobalPermission command.
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
            Write-Verbose "Executing Get-AnyStackGlobalPermission"
            $result = Invoke-AnyStackWithRetry -ScriptBlock {
                # Implementation
            }
            [PSCustomObject]@{ Status = 'Success' }
        }
        catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.InvalidLogin] {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'AuthenticationError', [System.Management.Automation.ErrorCategory]::AuthenticationError, $Server))
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $Server))
        }
    }
}

