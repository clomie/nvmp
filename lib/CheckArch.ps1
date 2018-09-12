function CheckArch {
  Param (
    [string]$Arch
  )

  if ($Arch -eq "") {
    $Arch = if ($ENV:PROCESSOR_ARCHITECTURE -eq "x86") { "x86" } else { "x64" }
  }
  if (($Arch -ne "x86") -and ($Arch -ne "x64")) {
    throw "Arch must be 'x86' or 'x64'"
  }

  $Arch
}