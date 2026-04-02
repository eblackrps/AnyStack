function Get-AnyStackHostLogBundle {
    <#
    .SYNOPSIS
        Generates a host log bundle.
    .DESCRIPTION
        Calls DiagnosticManager to generate and download a log bundle.
    .PARAMETER Server
        vCenter Server hostname or VIServer object. Uses active connection if omitted.
    .PARAMETER HostName
        Name of the host.
    .PARAMETER DestinationPath
        Path to save the bundle.
    .EXAMPLE
        PS> Get-AnyStackHostLogBundle -HostName 'esx01'
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
        [string]$HostName,
        [Parameter(Mandatory=$false)]
        [string]$DestinationPath = "$env:TEMP\logs"
    )
    begin {
        $ErrorActionPreference = 'Stop'
    }
    process {
        $vi = Get-AnyStackConnection -Server $Server
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Generating log bundle on $($vi.Name)"
            $diagMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.DiagnosticManager }
            $h = Get-AnyStackHostView -Server $vi -HostName $HostName -Property @('Name')
            
            $taskRef = if ($diagMgr -and $h -and $PSCmdlet.ShouldProcess($HostName, 'Generate host log bundle')) {
                Invoke-AnyStackWithRetry -ScriptBlock { $diagMgr.GenerateLogBundles_Task($false, @($h.MoRef)) }
            } else { $null }
            if ($taskRef) {
                Invoke-AnyStackWithRetry -ScriptBlock {
                    Get-Task -Id $taskRef.Value -Server $vi | Wait-Task -ErrorAction SilentlyContinue | Out-Null
                } | Out-Null
            }
            
            [PSCustomObject]@{
                PSTypeName = 'AnyStack.LogBundle'
                Timestamp  = (Get-Date)
                Server     = $vi.Name
                Host       = $HostName
                BundlePath = if (Test-Path $DestinationPath) { (Resolve-Path $DestinationPath).Path } else { $DestinationPath }
                BundleKey  = $taskRef.Value
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_.Exception, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}
