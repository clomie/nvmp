function GetCurrentVersion {
  Param (
    [parameter(mandatory=$true, position=1)]
    $InstallDir
  )

  # Get junctions like: "YYYY/MM/DD  HH:MM    <JUNCTION>     current [C:\Users\whoami\.nvmw\versions\vXX.X.X]"
  $junctions = &$ENV:COMSPEC /c dir /AL $InstallDir 2>&1 | where-object { $_ -match "<JUNCTION>" }

  if (-not $junctions) {
    Write-Host "Current version is not set. please run 'nvmw use' command."
    return
  }

  $path = $junctions | % { -Split $_ } | select-object -last 1 | % { $_ -Split "\[|\]" -Join "" }
  return Split-Path -Leaf $path
}