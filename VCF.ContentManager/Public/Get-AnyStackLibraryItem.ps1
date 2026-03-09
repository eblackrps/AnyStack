function Get-AnyStackLibraryItem {
    <#
    .SYNOPSIS
        Lists items in a Content Library.
    .DESCRIPTION
        Retrieves all items from the specified Content Library.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER LibraryName
        Name of the library to query.
    .EXAMPLE
        PS> Get-AnyStackLibraryItem -LibraryName 'Templates'
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
        [Parameter(Mandatory=$true)]
        [string]$LibraryName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Fetching library items from $LibraryName on $($vi.Name)"
            $lib = Invoke-AnyStackWithRetry -ScriptBlock { Get-ContentLibrary -Name $LibraryName -Server $vi }
            $items = Invoke-AnyStackWithRetry -ScriptBlock { Get-ContentLibraryItem -ContentLibrary $lib -Server $vi }
            
            foreach ($i in $items) {
                [PSCustomObject]@{
                    PSTypeName  = 'AnyStack.LibraryItem'
                    Timestamp   = (Get-Date)
                    Server      = $vi.Name
                    LibraryName = $LibraryName
                    ItemName    = $i.Name
                    ItemType    = $i.ItemType
                    SizeGB      = [Math]::Round($i.Size / 1GB, 2)
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



