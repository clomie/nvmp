function Unzip {
  Param(
    [parameter(mandatory=$true)]
    [string]$zipFile,
    [parameter(mandatory=$true)]
    [string]$outDir
  )

  $shell = New-Object -ComObject shell.application
  $zip = $shell.NameSpace($zipFile)
  $out = $shell.NameSpace($outDir)

  $items = $zip.items()
  $out.CopyHere($zip.items(), 0)

  $items
}
