Param (
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$PSScriptRoot\..\lib\Dirs.ps1"
. "$PSScriptRoot\..\lib\GetCurrentVersion.ps1"

Get-ChildItem (VersionsDir) | ? { $_.PSIsContainer } | % { Write-Host $_.Name }
