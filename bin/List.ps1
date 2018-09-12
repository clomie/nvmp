Param (
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$PSScriptRoot\..\lib\Dirs.ps1"
. "$PSScriptRoot\..\lib\GetCurrentVersion.ps1"

$Dir = VersionsDir
if (Test-Path $Dir) {
  Get-ChildItem $Dir | ? { $_.PSIsContainer } | % { Write-Host $_.Name }
}
