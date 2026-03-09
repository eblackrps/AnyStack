function New-AnyStackCustomRole {
    <#
    .SYNOPSIS
        Creates a custom role.
    .DESCRIPTION
        Adds a new authorization role with privileges.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER RoleName
        Name of the role.
    .PARAMETER Privileges
        Array of privileges.
    .PARAMETER Description
        Description of the role.
    .EXAMPLE
        PS> New-AnyStackCustomRole -RoleName 'Auditor' -Privileges 'System.View'
    .OUTPUTS
        PSCustomObject
    .NOTES
        Author: The AnyStack Architect
        Requires: VCF.PowerCLI 9.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$RoleName,
        [Parameter(Mandatory=$true)]
        [string[]]$Privileges,
        [Parameter(Mandatory=$false)]
        [string]$Description = ''
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($RoleName, "Create Custom Role")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Creating custom role on $($vi.Name)"
                $authMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.AuthorizationManager }
                
                $roleId = Invoke-AnyStackWithRetry -ScriptBlock { $authMgr.AddAuthorizationRole($RoleName, $Privileges) }
                
                [PSCustomObject]@{
                    PSTypeName     = 'AnyStack.CustomRole'
                    Timestamp      = (Get-Date)
                    Server         = $vi.Name
                    RoleName       = $RoleName
                    RoleId         = $roleId
                    PrivilegeCount = $Privileges.Count
                    Privileges     = $Privileges -join ','
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


