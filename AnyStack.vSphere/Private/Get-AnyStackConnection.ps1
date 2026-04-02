function Get-AnyStackConnection {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAlignAssignmentStatement", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentIndentation", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseConsistentWhitespace", "")]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        $Server
    )

    $activeConnections = @()
    foreach ($variableName in 'DefaultVIServers', 'defaultVIServers', 'DefaultVIServer', 'defaultVIServer') {
        $variable = Get-Variable -Name $variableName -Scope Global -ErrorAction SilentlyContinue
        if ($variable -and $null -ne $variable.Value) {
            $activeConnections += @($variable.Value)
        }
    }
    $activeConnections = @(
        $activeConnections |
            Where-Object { $_ -and $_.PSObject.Properties.Name -contains 'IsConnected' -and $_.IsConnected }
    )
    $activeConnections = @(
        $activeConnections |
            Group-Object {
                if ($_.PSObject.Properties.Name -contains 'Uid' -and $_.Uid) {
                    $_.Uid
                }
                elseif ($_.PSObject.Properties.Name -contains 'Name' -and $_.Name) {
                    $_.Name
                }
                else {
                    [System.Runtime.CompilerServices.RuntimeHelpers]::GetHashCode($_)
                }
            } |
            ForEach-Object { $_.Group[0] }
    )

    if ($null -eq $Server) {
        if ($activeConnections.Count -eq 1) {
            return $activeConnections[0]
        }

        if ($activeConnections.Count -gt 1) {
            throw "Multiple active vCenter Server connections found. Please specify -Server."
        }

        throw "No active vCenter Server connection found. Please use Connect-AnyStackServer first or pass -Server."
    }

    if ($Server -is [VMware.VimAutomation.Types.VIServer]) {
        return $Server
    }

    # Support PSCustomObject mock objects (e.g. in unit tests)
    if ($Server -is [PSCustomObject] -and $Server.PSObject.Properties.Name -contains 'IsConnected') {
        return $Server
    }

    if ($Server -is [string]) {
        $vi = $activeConnections |
            Where-Object { $_.Name -eq $Server } |
            Select-Object -First 1
        if ($null -eq $vi) {
            throw "Not connected to vCenter Server '$Server'. Please use Connect-AnyStackServer first."
        }
        return $vi
    }

    throw "Invalid Server parameter. Must be omitted, a server name, or a VIServer object."
}

 
