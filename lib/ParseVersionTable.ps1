function ParseVersionTable {
  Param(
    [parameter(mandatory=$true, position=1)]
    $Response
  )

  function ToHashmap($keys, $values) {
    $result = @{}
    for ($i = 0; $i -lt $values.Length; $i++) {
      $result[$keys[$i]] = $values[$i]
    }
    $result
  }

  $lines = $Response -Split "`n"
  $keys = -Split ($lines | Select-Object -First 1)
  $result = $lines | ? { $_ -Match "^v[1-9]" } | % { ToHashmap $keys (-Split $_) }

  $result
}