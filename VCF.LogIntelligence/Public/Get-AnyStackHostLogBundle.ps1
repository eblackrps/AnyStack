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
        Requires: VMware.PowerCLI 13.0+, vSphere 8.0 U3+
    #>
    [CmdletBinding(SupportsShouldProcess=$false)]
    [OutputType([PSCustomObject])]
    param(
        [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
        [ValidateNotNull()]
        $Server,
        [Parameter(Mandatory=$true)]
        [string]$HostName,
        [Parameter(Mandatory=$false)]
        [string]$DestinationPath = '.\logs'
    )
    begin {
        $vi = Get-AnyStackConnection -Server $Server
        $ErrorActionPreference = 'Stop'
    }
    process {
        try {
            Write-Verbose "[$($MyInvocation.MyCommand.Name)] Generating log bundle on $($vi.Name)"
            $diagMgr = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -Id $vi.ExtensionData.Content.DiagnosticManager }
            $h = Invoke-AnyStackWithRetry -ScriptBlock { Get-View -Server $vi -ViewType HostSystem -Filter @{Name=$HostName} }
            
            $taskRef = Invoke-AnyStackWithRetry -ScriptBlock { $diagMgr.GenerateLogBundles_Task($false, @($h.MoRef)) }
            $task = Get-Task -Id $taskRef.Value -Server $vi
            $task | Wait-Task -ErrorAction Stop | Out-Null
            
            [PSCustomObject]@{
                PSTypeName = 'AnyStack.LogBundle'
                Timestamp  = (Get-Date)
                Server     = $vi.Name
                Host       = $HostName
                BundlePath = (Resolve-Path $DestinationPath).Path
                BundleKey  = $taskRef.Value
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError([System.Management.Automation.ErrorRecord]::new($_, 'UnexpectedError', [System.Management.Automation.ErrorCategory]::NotSpecified, $null))
        }
    }
}

 

