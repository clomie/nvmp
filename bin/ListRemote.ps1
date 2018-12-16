Param (
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$PSScriptRoot\..\lib\Downloads.ps1"
. "$PSScriptRoot\..\lib\Urls.ps1"
. "$PSScriptRoot\..\lib\ParseVersionTable.ps1"

$VersionTable = ParseVersionTable (DownloadString (NodeIndexTableUrl))

Write-Host "version   npm      date       lts"
Write-Host "--------- -------- ---------- ----------"
$VersionTable[($VersionTable.length - 1) .. 0] | ForEach-Object {
  Write-Host ("{0,-9} {1,-8} {2,-10} {3}" -F $_.version, $_.npm, $_.date, $_.lts)
}
Write-Host;