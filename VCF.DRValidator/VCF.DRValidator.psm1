# VCF.DRValidator Module Script (.psm1)
# Author: The Any Stack Architect
# Purpose: Advanced Disaster Recovery Readiness Validation

$PublicPath  = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$PrivatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

$ImportPaths = @($PrivatePath, $PublicPath)
foreach ($Path in $ImportPaths) {
    if (Test-Path -Path $Path) {
        $Files = Get-ChildItem -Path $Path -Filter *.ps1 -File
        foreach ($File in $Files) { . $File.FullName }
    }
}

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Write-Verbose "VCF.DRValidator module is being unloaded."
}

Write-Verbose "VCF.DRValidator module loaded successfully."
 

