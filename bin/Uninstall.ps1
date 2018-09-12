Param (
  [parameter(mandatory=$true, position=1)]
  [string]$Version,

  [parameter(position=2)]
  [string]$Arch
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$PSScriptRoot\..\lib\CheckArch.ps1"
. "$PSScriptRoot\..\lib\Dirs.ps1"

$Arch = CheckArch $Arch
$Dirs = ResolveDirs $Version $Arch

if (!(Test-Path $Dirs.Node)) {
  Write-Host "$($Version)-$($Arch) is not installed."
  return
}

Write-Host "Removing $($Version)-$($Arch)"
Remove-Item -Force -Recurse $Dirs.Node
Write-Host "Finished uninstall successfully."