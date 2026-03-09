function Sync-AnyStackContentLibrary {
    <#
    .SYNOPSIS
        Syncs a content library.
    .DESCRIPTION
        Invokes Sync-ContentLibrary on a subscribed library.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER LibraryName
        Name of the library to sync.
    .EXAMPLE
        PS> Sync-AnyStackContentLibrary -LibraryName 'SubscribedLib'
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
        [string]$LibraryName
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            if ($PSCmdlet.ShouldProcess($LibraryName, "Sync Content Library")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Syncing content library on $($vi.Name)"
                $lib = Invoke-AnyStackWithRetry -ScriptBlock { Get-ContentLibrary -Name $LibraryName -Server $vi }
                if ($lib) {
                    Invoke-AnyStackWithRetry -ScriptBlock { Sync-ContentLibrary -ContentLibrary $lib }
                    $items = Invoke-AnyStackWithRetry -ScriptBlock { Get-ContentLibraryItem -ContentLibrary $lib -Server $vi }
                    
                    [PSCustomObject]@{
                        PSTypeName  = 'AnyStack.ContentLibrarySync'
                        Timestamp   = (Get-Date)
                        Server      = $vi.Name
                        LibraryName = $LibraryName
                        SyncStatus  = 'Complete'
                        ItemCount   = if ($items) { $items.Count } else { 0 }
                        LastSync    = (Get-Date)
                        Errors      = 0
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 


