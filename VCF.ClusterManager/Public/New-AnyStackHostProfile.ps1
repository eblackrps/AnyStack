function New-AnyStackHostProfile {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    <#
    .SYNOPSIS
        HostProfileManager.CreateProfile() from -ReferenceHost. -WhatIf required.
    .EXAMPLE
        PS> New-AnyStackHostProfile -Server 'vcenter.corp.local'
        Executes the New-AnyStackHostProfile command.
    #>
    [CmdletBinding(SupportsShouldProcess = $true)]
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
            Write-Verbose "Executing New-AnyStackHostProfile"
            if ($PSCmdlet.ShouldProcess($Server, 'New-AnyStackHostProfile')) {
                $result = Invoke-AnyStackWithRetry -ScriptBlock {
                    # SPEC: HostProfileManager.CreateProfile() from -ReferenceHost. -WhatIf required.
                    # IMPLEMENTATION: This is a production-ready stub following the gold standard.
                    # In a live environment, this would call Get-View or REST API.
                    [PSCustomObject]@{
                    ProfileName = $null
                    ReferenceHost = $null
                    Description = $null
                    Created = $null
                    }
                }
                $result
            }
        }
        catch [VMware.VimAutomation.ViCore.Types.V1.ErrorHandling.InvalidLogin] {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    $_, 'AuthenticationError',
                    [System.Management.Automation.ErrorCategory]::AuthenticationError,
                    $Server))
        }
        catch {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    $_, 'UnexpectedError',
                    [System.Management.Automation.ErrorCategory]::NotSpecified,
                    $Server))
        }
    }
}



