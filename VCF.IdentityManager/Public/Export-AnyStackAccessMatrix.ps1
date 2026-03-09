function Export-AnyStackAccessMatrix {
    <#
    .SYNOPSIS
        Exports an access matrix.
    .DESCRIPTION
        Retrieves all permissions and exports them.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER OutputPath
        Output CSV path.
    .EXAMPLE
        PS> Export-AnyStackAccessMatrix
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
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = ".\AccessMatrix-$(Get-Date -f yyyyMMdd).csv"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting access matrix on $($vi.Name)"
            $authMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.AuthorizationManager }
            $perms = Invoke-AnyStackWithRetry -ScriptBlock { $authMgr.RetrieveAllPermissions() }
            
            $perms | Select-Object Principal, RoleId, Entity, Propagate | Export-Csv -Path $OutputPath -NoTypeInformation
            
            [PSCustomObject]@{
                PSTypeName        = 'AnyStack.AccessMatrix'
                Timestamp         = (Get-Date)
                Server            = $vi.Name
                ReportPath        = (Resolve-Path $OutputPath).Path
                PrincipalCount    = ($perms.Principal | Select-Object -Unique).Count
                PermissionCount   = $perms.Count
                GlobalPermissions = ($perms | Where-Object { $_.Entity.Type -eq 'Folder' }).Count
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Export-AnyStackAccessMatrix {
    <#
    .SYNOPSIS
        Exports an access matrix.
    .DESCRIPTION
        Retrieves all permissions and exports them.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER OutputPath
        Output CSV path.
    .EXAMPLE
        PS> Export-AnyStackAccessMatrix
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
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = ".\AccessMatrix-$(Get-Date -f yyyyMMdd).csv"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting access matrix on $($vi.Name)"
            $authMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.AuthorizationManager }
            $perms = Invoke-AnyStackWithRetry -ScriptBlock { $authMgr.RetrieveAllPermissions() }
            
            $perms | Select-Object Principal, RoleId, Entity, Propagate | Export-Csv -Path $OutputPath -NoTypeInformation
            
            [PSCustomObject]@{
                PSTypeName        = 'AnyStack.AccessMatrix'
                Timestamp         = (Get-Date)
                Server            = $vi.Name
                ReportPath        = (Resolve-Path $OutputPath).Path
                PrincipalCount    = ($perms.Principal | Select-Object -Unique).Count
                PermissionCount   = $perms.Count
                GlobalPermissions = ($perms | Where-Object { $_.Entity.Type -eq 'Folder' }).Count
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Export-AnyStackAccessMatrix {
    <#
    .SYNOPSIS
        Exports an access matrix.
    .DESCRIPTION
        Retrieves all permissions and exports them.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER OutputPath
        Output CSV path.
    .EXAMPLE
        PS> Export-AnyStackAccessMatrix
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
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = ".\AccessMatrix-$(Get-Date -f yyyyMMdd).csv"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting access matrix on $($vi.Name)"
            $authMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.AuthorizationManager }
            $perms = Invoke-AnyStackWithRetry -ScriptBlock { $authMgr.RetrieveAllPermissions() }
            
            $perms | Select-Object Principal, RoleId, Entity, Propagate | Export-Csv -Path $OutputPath -NoTypeInformation
            
            [PSCustomObject]@{
                PSTypeName        = 'AnyStack.AccessMatrix'
                Timestamp         = (Get-Date)
                Server            = $vi.Name
                ReportPath        = (Resolve-Path $OutputPath).Path
                PrincipalCount    = ($perms.Principal | Select-Object -Unique).Count
                PermissionCount   = $perms.Count
                GlobalPermissions = ($perms | Where-Object { $_.Entity.Type -eq 'Folder' }).Count
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new(function Export-AnyStackAccessMatrix {
    <#
    .SYNOPSIS
        Exports an access matrix.
    .DESCRIPTION
        Retrieves all permissions and exports them.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER OutputPath
        Output CSV path.
    .EXAMPLE
        PS> Export-AnyStackAccessMatrix
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
        $Server,
        [Parameter(Mandatory=$false)]
        [string]$OutputPath = ".\AccessMatrix-$(Get-Date -f yyyyMMdd).csv"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting access matrix on $($vi.Name)"
            $authMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.AuthorizationManager }
            $perms = Invoke-AnyStackWithRetry -ScriptBlock { $authMgr.RetrieveAllPermissions() }
            
            $perms | Select-Object Principal, RoleId, Entity, Propagate | Export-Csv -Path $OutputPath -NoTypeInformation
            
            [PSCustomObject]@{
                PSTypeName        = 'AnyStack.AccessMatrix'
                Timestamp         = (Get-Date)
                Server            = $vi.Name
                ReportPath        = (Resolve-Path $OutputPath).Path
                PrincipalCount    = ($perms.Principal | Select-Object -Unique).Count
                PermissionCount   = $perms.Count
                GlobalPermissions = ($perms | Where-Object { $_.Entity.Type -eq 'Folder' }).Count
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 




.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 




