function Remove-AnyStackStaleTag {
    <#
    .SYNOPSIS
        Removes unused tags.
    .DESCRIPTION
        Deletes tags not assigned to any entity.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER CategoryName
        Filter by category.
    .EXAMPLE
        PS> Remove-AnyStackStaleTag
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
        [Parameter(Mandatory=$false)]
        [string]$CategoryName
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Finding stale tags on $($vi.Name)"
            $allTags = Invoke-AnyStackWithRetry -ScriptBlock { Get-Tag -Server $vi }
            $usedTags = Invoke-AnyStackWithRetry -ScriptBlock { Get-TagAssignment -Server $vi | Select-Object -ExpandProperty Tag }
            
            $staleTags = $allTags | Where-Object { $_.Name -notin $usedTags.Name }
            
            foreach ($t in $staleTags) {
                if ($PSCmdlet.ShouldProcess($t.Name, "Remove Tag")) {
                    Invoke-AnyStackWithRetry -ScriptBlock { Remove-Tag -Tag $t -Confirm:$false }
                    
                    [PSCustomObject]@{
                        PSTypeName    = 'AnyStack.RemovedTag'
                        Timestamp     = (Get-Date)
                        Server        = $vi.Name
                        TagName       = $t.Name
                        Category      = $t.Category.Name
                        ObjectsTagged = 0
                        Removed       = $true
                    }
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
