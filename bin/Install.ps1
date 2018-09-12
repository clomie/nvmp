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
  if ($FileName -eq $null) {
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

$NodeVersionInfo = ParseVersionTable (DownloadString (NodeIndexTableUrl)) | ? { $_.version -eq $Version }

if ([string]::IsNullOrEmpty($NodeVersionInfo)) {
  throw "$Version is not available"
}

$NpmVersion = $NodeVersionInfo.npm
Write-Host @"
Install versions
  node : $Version
  npm  : $NpmVersion
"@

if (Test-Path $Dirs.Node) {
  if ($Force) {
    Write-Host "Removing $($Dirs.Node)" -ForegroundColor Red
    Remove-Item -Force -Recurse $Dirs.Node
  } else {
    throw "Already exists $($Dirs.Node), please uninstall first."
  }
}

$NodeBinUrl = NodeBinUrl $Version $Arch
$NodeBinPath = fget $NodeBinUrl $Dirs.Node

$NpmZipUrl = NpmZipUrl $NpmVersion
$NpmZipPath = fget $NpmZipUrl $Dirs.Node "npm.zip"

Write-Host "Install npm to $($Dirs.Npm) ..."
New-Item $Dirs.Modules -ItemType Directory -Force | Out-Null
$NpmUnzipPaths = Unzip $NpmZipPath $Dirs.Modules

$NpmUnzipPath = Join-Path $Dirs.Modules ($NpmUnzipPaths | Select-Object -First 1).Name
Move-Item $NpmUnzipPath $Dirs.Npm

Copy-Item -Path "$($Dirs.Npm)\bin\*" -Destination $Dirs.Node -Include "npm", "npm.cmd", "npx", "npx.cmd"

Write-Host "Finished install successfully."
