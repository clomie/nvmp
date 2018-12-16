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
  throw "Not installed $Version $Arch"
}

if (Test-Path $Dirs.Current) {
  (Get-Item $Dirs.Current).Delete()
}

&$ENV:COMSPEC /c mklink /j $Dirs.Current $Dirs.Node

$Path = [Environment]::GetEnvironmentVariable('Path', 'User')
if (-Not $Path.Contains($Dirs.Current)) {
  $NewPath = $Dirs.Current + ";" + $Path
  [Environment]::SetEnvironmentVariable('Path', $NewPath, 'User')
}