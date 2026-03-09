$PublicPath  = Join-Path -Path $PSScriptRoot -ChildPath 'Public'
$PrivatePath = Join-Path -Path $PSScriptRoot -ChildPath 'Private'

foreach ($Path in @($PrivatePath, $PublicPath)) {
    if (Test-Path -Path $Path) {
        $Files = Get-ChildItem -Path $Path -Filter *.ps1 -File
        foreach ($File in $Files) { . $File.FullName }
    }
}
 


