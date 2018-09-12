function InstallDir {
  return "$ENV:USERPROFILE\.nvmp"
}

function CurrentVersionDir {
  return "$(InstallDir)\current"
}

function VersionsDir {
  return "$(InstallDir)\versions"
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
  $ModulesDir = Join-Path $NodeDir "node_modules"
  $NpmDir = Join-Path $ModulesDir "npm"

  return @{
    Current = $CurrentDir;
    Versions = $VersionsDir;
    Node = $NodeDir;
    Modules = $ModulesDir;
    Npm = $NpmDir
  }
}