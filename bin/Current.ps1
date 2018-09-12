Param (
)

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$PSScriptRoot\..\lib\Dirs.ps1"
. "$PSScriptRoot\..\lib\GetCurrentVersion.ps1"

GetCurrentVersion (InstallDir)
