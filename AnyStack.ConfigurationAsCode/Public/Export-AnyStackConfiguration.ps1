function Export-AnyStackConfiguration {
    <#
    .SYNOPSIS
        Exports vCenter configuration to a structured JSON file.
    .DESCRIPTION
        Retrieves settings like folders, clusters, and networks and saves them for Configuration as Code (CaC).
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER OutputPath
        Path to the output JSON file.
    .EXAMPLE
        PS> Export-AnyStackConfiguration -OutputPath 'C:\Backup\Config.json'
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
        [string]$OutputPath = ".\vCenterConfig-$(Get-Date -f yyyyMMdd).json"
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Exporting configuration from $($vi.Name)"
            $config = @{
                Server = $vi.Name
                ExportDate = (Get-Date)
                Folders = Invoke-AnyStackWithRetry -ScriptBlock { Get-Folder -Server $vi | Select-Object Name, Type }
                Clusters = Invoke-AnyStackWithRetry -ScriptBlock { Get-Cluster -Server $vi | Select-Object Name, DrsEnabled, HaEnabled }
            }
            
            $config | ConvertTo-Json -Depth 5 | Set-Content -Path $OutputPath -Encoding UTF8
            
            [PSCustomObject]@{
                PSTypeName = 'AnyStack.ConfigurationExport'
                Timestamp  = (Get-Date)
                Status     = 'Success'
                Server     = $vi.Name
                OutputPath = (Resolve-Path $OutputPath).Path
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 



