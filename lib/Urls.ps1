function NodeDistUrl {
  return "https://nodejs.org/dist"
}

function NpmArchiveUrl {
  return "https://codeload.github.com/npm/cli/zip"
}

function NodeIndexTableUrl {
  return "$(NodeDistUrl)/index.tab"
}

function NodeBinUrl ($Version, $Arch) {
  return "$(NodeDistUrl)/$($Version)/win-$($Arch)/node.exe"
}

function NpmZipUrl ($Version) {
  return "$(NpmArchiveUrl)/v$Version"
}