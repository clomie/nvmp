Param (
  [parameter(mandatory=$true, position=1)]
  [string]$Version,

  [parameter(position=2)]
  [string]$Arch,

  [switch]$Force
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$PSScriptRoot\..\lib\Downloads.ps1"
. "$PSScriptRoot\..\lib\Unzip.ps1"
. "$PSScriptRoot\..\lib\CheckArch.ps1"
. "$PSScriptRoot\..\lib\Dirs.ps1"
. "$PSScriptRoot\..\lib\Urls.ps1"
. "$PSScriptRoot\..\lib\ParseVersionTable.ps1"

function fget ($Url, $Dir, $FileName) {
  if ($null -eq $FileName) {
    $FileName = $Url -Split "/" | Select-Object -Last 1
  }
  $Path = Join-Path $Dir $FileName

  if (!(Test-Path $Dir)) {
    New-Item $Dir -ItemType Directory -Force | Out-Null
  }

  Write-Host "Download $Url to $Path"
  DownloadFile $Url $Path

  if (!(Test-Path $Path)) {
    throw "Failed to download $Url"
  }

  $Path
}

$Arch = CheckArch $Arch
$Dirs = ResolveDirs $Version $Arch

$NodeVersionInfo = ParseVersionTable (DownloadString (NodeIndexTableUrl)) | Where-Object { $_.version -eq $Version }

if ([string]::IsNullOrEmpty($NodeVersionInfo)) {
  throw "$Version is not available"
}

$NpmVersion = $NodeVersionInfo.npm
Write-Host "Install Node.js $Version / npm $NpmVersion"

if (Test-Path $Dirs.Node) {
  if ($Force) {
    Write-Host "Removing $($Dirs.Node)" -ForegroundColor Red
    Remove-Item -Force -Recurse $Dirs.Node
  } else {
    throw "$($Dirs.Node) is already installed. If you want to re-install it, please try '-Force' option."
  }
}

$NodeZipUrl = NodeZipUrl $Version $Arch
$NodeZipPath = fget $NodeZipUrl $Dirs.Versions

Write-Host "Unzipping..."

$NodeUnzipPaths = Unzip $NodeZipPath $Dirs.Versions
$NodeUnzipPath = Join-Path $Dirs.Versions ($NodeUnzipPaths | Select-Object -First 1).Name
Move-Item $NodeUnzipPath $Dirs.Node

Write-Host "Finished install successfully."
