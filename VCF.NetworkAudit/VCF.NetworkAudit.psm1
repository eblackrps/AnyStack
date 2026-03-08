# VCF.NetworkAudit Module Script (.psm1)
# Author: The Any Stack Architect

$PublicPath  = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$PrivatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

$ImportPaths = @($PrivatePath, $PublicPath)
foreach ($Path in $ImportPaths) {
    if (Test-Path -Path $Path) {
        $Files = Get-ChildItem -Path $Path -Filter *.ps1 -File
        foreach ($File in $Files) { . $File.FullName }
    }
}

Write-Verbose "VCF.NetworkAudit module loaded successfully."
