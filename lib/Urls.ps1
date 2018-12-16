function NodeDistUrl {
  return "https://nodejs.org/dist"
}

function NodeIndexTableUrl {
  return "$(NodeDistUrl)/index.tab"
}

function NodeZipUrl ($Version, $Arch) {
  return "$(NodeDistUrl)/$($Version)/node-$($Version)-win-$($Arch).zip"
}
