function NewWebClient {
  $WebClient = New-Object System.Net.WebClient
  $Proxy = [System.Net.WebRequest]::GetSystemWebProxy()
  $Proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
  $WebClient.UseDefaultCredentials = $true
  $WebClient.Proxy.Credentials = $WebClient.Credentials
  return $WebClient
}

function DownloadString {
  Param(
    [parameter(mandatory=$true)]
    [string]$url
  )
  try {
    $WebClient = NewWebClient
    return $WebClient.DownloadString($url)
  } finally {
    $WebClient.Dispose()
  }
}


function DownloadFile {
  Param(
    [parameter(mandatory=$true)]
    [string]$url,

    [parameter(mandatory=$true)]
    [string]$path
  )

  try {

    $WebClient = NewWebClient

    Get-EventSubscriber `
      | % { $_.SourceIdentifier } `
      | ? { $_ -eq "WebClient.DownloadFileCompleted" -or $_ -eq "WebClient.DownloadProgressChanged" } `
      | % { Unregister-Event -SourceIdentifier $_ }

    $Global:DownloadFileCompleted = $false
    $Global:DownloadFileProgress = $null

    $CompletedEvent = Register-ObjectEvent $WebClient DownloadFileCompleted `
        -SourceIdentifier WebClient.DownloadFileCompleted `
        -Action { $Global:DownloadFileCompleted = $true }

    $ProgressChangedEvent = Register-ObjectEvent $WebClient DownloadProgressChanged `
        -SourceIdentifier WebClient.DownloadProgressChanged `
        -Action { $Global:DownloadFileProgress = $Event }

    $WebClient.DownloadFileAsync($url, $path)

    do {
      $percent = $Global:DownloadFileProgress.SourceEventArgs.ProgressPercentage
      $totalBytes = $Global:DownloadFileProgress.SourceEventArgs.TotalBytesToReceive
      $receivedBytes = $Global:DownloadFileProgress.SourceEventArgs.BytesReceived
      if ($percent -ne $null) {
          Write-Progress -PercentComplete $percent `
            -Activity ("Downloading {0} into {1}" -f $url, $path) `
            -Status ("{0}% ({1} / {2} bytes)" -f $percent, $receivedBytes, $totalBytes)
      }
      # Start-Sleep -m 50
    } while (-Not $Global:DownloadFileCompleted)

    Write-Progress -Completed `
        -Activity ("Downloading {0} into {1}" -f $url, $path) `
        -Status ("{0}% ({1} / {2} bytes)" -f $percent, $receivedBytes, $totalBytes)

  } finally {

    if (-Not $Global:DownloadFileCompleted) {
      $WebClient.CancelAsync()
    }

    $WebClient.Dispose()
    Unregister-Event -SourceIdentifier WebClient.DownloadFileCompleted | Out-Null
    Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged | Out-Null

    Remove-Variable -Scope Global DownloadFileCompleted
    Remove-Variable -Scope Global DownloadFileProgress
  }
}
