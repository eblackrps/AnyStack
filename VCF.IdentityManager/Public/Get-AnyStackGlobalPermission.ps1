function Get-AnyStackGlobalPermission {
    <#
    .SYNOPSIS
        Retrieves global permissions in vCenter.
    .DESCRIPTION
        Queries AuthorizationManager for permissions applied at the root level.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .EXAMPLE
        PS> Get-AnyStackGlobalPermission
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
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching global permissions on $($vi.Name)"
            $authMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.AuthorizationManager }
            $perms = Invoke-AnyStackWithRetry -ScriptBlock { $authMgr.RetrieveAllPermissions() }
            
            $globalPerms = $perms | Where-Object { $_.Entity.Type -eq 'Folder' -and $_.Entity.Value -match 'group-d' }
            
            foreach ($p in $globalPerms) {
                [PSCustomObject]@{
                    PSTypeName = 'AnyStack.GlobalPermission'
                    Timestamp  = (Get-Date)
                    Server     = $vi.Name
                    Principal  = $p.Principal
                    RoleId     = $p.RoleId
                    Propagate  = $p.Propagate
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



