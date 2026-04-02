function Sync-AnyStackAutomationScripts {
    <#
    .SYNOPSIS
        Syncs automation scripts to OptionManager.
    .DESCRIPTION
        Compares Get-FileHash of local scripts vs OptionManager stored hashes and updates.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER LocalScriptPath
        Path to local scripts folder.
    .PARAMETER RemoteLibraryPath
        Optional remote library path reference.
    .EXAMPLE
        PS> Sync-AnyStackAutomationScripts -LocalScriptPath 'C:\Scripts'
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
        [string]$LocalScriptPath,
        [Parameter(Mandatory=$false)]
        [string]$RemoteLibraryPath
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            if ($PSCmdlet.ShouldProcess($vi.Name, "Sync Automation Scripts from $LocalScriptPath")) {
                Write-Verbose "[$($MyInvocation.MyCommand.Name)] Syncing scripts on $($vi.Name)"
                $optMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.Setting }
                $existingOpts = if ($optMgr) { $optMgr.QueryView() } else { @() }
                
                $scripts = Get-ChildItem -Path $LocalScriptPath -Filter *.ps1
                $synced = 0
                $skipped = 0
                
                foreach ($script in $scripts) {
                    $hash = (Get-FileHash $script.FullName).Hash
                    $key = "AnyStack.Script.$($script.Name)"
                    $match = $existingOpts | Where-Object { $_.Key -eq $key }
                    
                    if (-not $match -or $match.Value -ne $hash) {
                        Invoke-AnyStackWithRetry -ScriptBlock { 
                            $optMgr.UpdateValues(@([VMware.Vim.OptionValue]@{ Key = $key; Value = $hash })) 
                        }
                        $synced++
                    } else {
                        $skipped++
                    }
                }
                
                [PSCustomObject]@{
                    PSTypeName     = 'AnyStack.ScriptSync'
                    Timestamp      = (Get-Date)
                    Server         = $vi.Name
                    ScriptsChecked = $scripts.Count
                    ScriptsSynced  = $synced
                    ScriptsSkipped = $skipped
                    Errors         = 0
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
