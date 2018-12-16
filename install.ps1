$NvmpPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$Path = [environment]::getEnvironmentVariable('PATH', 'User')
$Path = "$ENV:USERPROFILE\.nvmp\current;$NvmpPath;$Path"
[environment]::setEnvironmentVariable('PATH', $Path, 'User')

$ENV:Path = "$ENV:USERPROFILE\.nvmp\current;$NvmpPath;$ENV:Path"
