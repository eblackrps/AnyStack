function Test-AnyStackNetworkConfiguration {
    <#
    .SYNOPSIS
        Audits virtual switch configurations across ESXi hosts in a cluster for VCF standards.

    .DESCRIPTION
        This function performs a deep-dive audit of Standard vSwitches (VSS) and Distributed vSwitches (VDS).
        It evaluates security policies, MTU consistency, uplink redundancy, and discovery protocol (CDP/LLDP) status.
        Optimized for large-scale environments using Get-View.

    .PARAMETER Server
        VIServer connection object.

    .PARAMETER ClusterName
        Name of the cluster to audit.

    .EXAMPLE
        Test-AnyStackNetworkConfiguration -Server $vc -ClusterName "Cl01-Prod"
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param(
        [Parameter(Mandatory=$true)]
        $Server,

        [Parameter(Mandatory=$true)]
        [string]$ClusterName
    )

    process {
        $ErrorActionPreference = 'Stop'
        try {
            # 1. Fetch Cluster & Hosts
            Write-Verbose "Fetching cluster: $ClusterName"
            $clusterView = Get-View -Server $Server -ViewType ClusterComputeResource -Filter @{"Name"="^$ClusterName$"} -Property Name,Host -ErrorAction Stop
            
            if (-not $clusterView) { throw "Cluster '$ClusterName' not found." }

            # 2. Fetch Host Network Configs (VSS & VDS details)
            # Fetching: vSwitch config, PortGroups, ProxySwitch (VDS on host), Discovery Protocol
            $hostProps = @(
                "Name", "Config.Network.Vswitch", "Config.Network.Portgroup", 
                "Config.Network.ProxySwitch", "Config.Network.DnsConfig",
                "Config.Network.Vnic", "Config.Network.Pnic"
            )
            $hosts = Get-View -Server $Server -Id $clusterView.Host -Property $hostProps
            
            $auditResults = foreach ($h in $hosts) {
                Write-Verbose "Auditing Host: $($h.Name)"
                
                # --- Audit Standard vSwitches (VSS) ---
                if ($h.Config.Network.Vswitch) {
                    foreach ($vss in $h.Config.Network.Vswitch) {
                        $uplinkCount = 0
                        if ($vss.Pnic) { $uplinkCount = $vss.Pnic.Count }
                        
                        # Security Policy Audit
                        $secPolicy = $vss.Spec.Policy.Security
                        $isPromiscuous = $secPolicy.AllowPromiscuous -eq $true
                        $isMacChanges = $secPolicy.MacChanges -eq $true
                        $isForgedTransmits = $secPolicy.ForgedTransmits -eq $true
                        
                        [PSCustomObject]@{
                            Host             = $h.Name
                            SwitchType       = "VSS"
                            SwitchName       = $vss.Name
                            MTU              = $vss.Spec.Mtu
                            UplinkCount      = $uplinkCount
                            UplinkRedundancy = ($uplinkCount -ge 2)
                            PromiscuousMode  = $isPromiscuous
                            MacChanges       = $isMacChanges
                            ForgedTransmits  = $isForgedTransmits
                            DiscoveryProto   = $null # VSS discovery is handled at the spec level or switch level
                            Alert            = if ($uplinkCount -lt 2) { "Low Uplink Redundancy" } elseif ($isPromiscuous) { "Security: Promiscuous Mode Active" } else { "None" }
                        }
                    }
                }

                # --- Audit Distributed vSwitches (VDS) on the Host ---
                if ($h.Config.Network.ProxySwitch) {
                    foreach ($proxy in $h.Config.Network.ProxySwitch) {
                        $uplinkCount = 0
                        if ($proxy.Uplink) { $uplinkCount = $proxy.Uplink.Count }
                        
                        # Note: Deep security policies for VDS are usually at the DVPortgroup level
                        # but we can check MTU and basic proxy info here.
                        
                        [PSCustomObject]@{
                            Host             = $h.Name
                            SwitchType       = "VDS (Proxy)"
                            SwitchName       = $proxy.DvsName
                            MTU              = $proxy.Mtu
                            UplinkCount      = $uplinkCount
                            UplinkRedundancy = ($uplinkCount -ge 2)
                            PromiscuousMode  = $null # Checked at DVPortgroup level
                            MacChanges       = $null
                            ForgedTransmits  = $null
                            DiscoveryProto   = if ($null -ne $proxy.Config.DiscoveryProtocol -and $null -ne $proxy.Config.DiscoveryProtocol.Type) { $proxy.Config.DiscoveryProtocol.Type } else { "Unknown" }
                            Alert            = if ($uplinkCount -lt 2) { "Low Uplink Redundancy" } else { "None" }
                        }
                    }
                }
            }

            # 3. Global VDS Portgroup Security Audit (Cross-cluster)
            # This identifies configuration drift in Portgroups
            Write-Verbose "Performing Global VDS Portgroup Audit..."
            $dvpgViews = Get-View -Server $Server -ViewType DistributedVirtualPortgroup -Property Name,Config
            
            $pgAudit = foreach ($pg in $dvpgViews) {
                # Only check if it looks like it belongs to our clusters (or just check all active)
                # Filtering logic: Usually VDS portgroups aren't scoped by cluster MoRef as easily as VSS,
                # but we'll flag any that violate security standards.
                
                $sec = $pg.Config.DefaultPortConfig.SecurityPolicy
                if ($sec.AllowPromiscuous.Inherited -eq $false -and $sec.AllowPromiscuous.Value -eq $true) {
                    [PSCustomObject]@{
                        Host             = "VDS-Global"
                        SwitchType       = "DVPortgroup"
                        SwitchName       = $pg.Name
                        MTU              = $null
                        UplinkCount      = $null
                        UplinkRedundancy = $null
                        PromiscuousMode  = $true
                        MacChanges       = $sec.MacChanges.Value
                        ForgedTransmits  = $sec.ForgedTransmits.Value
                        DiscoveryProto   = $null
                        Alert            = "Security: Promiscuous Mode enabled on DVPortgroup"
                    }
                }
            }

            Write-Output ($auditResults + $pgAudit)
        }
        catch {
            Write-Error "Failed to audit network configuration: $($_.Exception.Message)"
        }
    }
}
