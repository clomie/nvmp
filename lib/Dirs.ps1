function NvmpDir {
  return "$ENV:USERPROFILE\.nvmp"
}

function CurrentVersionDir {
  return "$(NvmpDir)\current"
}

function VersionsDir {
  return "$(NvmpDir)\versions"
}

function ResolveDirs {
  Param (
    [parameter(mandatory=$true)]
    [string]$Version,

    [parameter(mandatory=$true)]
    [string]$Arch
  )

  $OsArch = if ($ENV:PROCESSOR_ARCHITECTURE -eq "x86") { "x86" } else { "x64" }
  $Version = if ($Arch -eq $OsArch) { $Version } else { "$Version-$Arch" }

  $CurrentDir = CurrentVersionDir
  $VersionsDir = VersionsDir
  $NodeDir = Join-Path $VersionsDir $Version

  return @{
    Current = $CurrentDir;
    Versions = $VersionsDir;
    Node = $NodeDir;
  }
}