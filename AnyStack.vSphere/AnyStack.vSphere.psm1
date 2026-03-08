# AnyStack.vSphere Module Script (.psm1)
# Author: The Any Stack Architect
# Purpose: Advanced vSphere Infrastructure Automation

# Path to public/private functions
$PublicPath  = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$PrivatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

$ImportPaths = @($PrivatePath, $PublicPath)
foreach ($Path in $ImportPaths) {
    if (Test-Path -Path $Path) {
        $Files = Get-ChildItem -Path $Path -Filter *.ps1 -File
        foreach ($File in $Files) { . $File.FullName }
    }
}

# Module cleanup logic
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Write-Verbose "AnyStack.vSphere module is being unloaded. Cleaning up sessions..."
    if (Get-Module -Name VMware.VimAutomation.Core -ErrorAction SilentlyContinue) {
        # Optional: Force disconnect logic here if desired
    }
}

Write-Verbose "AnyStack.vSphere module loaded successfully."


 

