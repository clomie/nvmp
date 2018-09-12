@echo off
setlocal enabledelayedexpansion
set "BASEDIR=%~dp0"

if "%1" == "install" if not "%2" == "" (
  call :install %2 %3 %4
  if not ERRORLEVEL == 1 call :use %2 %3
  exit /b %ERRORLEVEL%
)

if "%1" == "uninstall" if not "%2" == "" (
  call :uninstall %2 %3
  exit /b %ERRORLEVEL%
)

if "%1" == "use" if not "%2" == "" (
  call :use %2 %3
  exit /b %ERRORLEVEL%
)

if "%1" == "current" (
  call :current
  exit /b %ERRORLEVEL%
)

if "%1" == "ls" (
  call :ls
  exit /b %ERRORLEVEL%
)

if "%1" == "ls-remote" (
  call :ls_remote
  exit /b %ERRORLEVEL%
)

call :help
exit /b %ERRORLEVEL%

::===========================================================
:: help : Show help message
::===========================================================
:help
powershell -NoProfile "%BASEDIR%\bin\Help.ps1" %*
exit /b 0

:install
powershell -NoProfile "%BASEDIR%\bin\Install.ps1" %*
exit /b %ERRORLEVEL%

:uninstall
powershell -NoProfile "%BASEDIR%\bin\Uninstall.ps1" %*
exit /b %ERRORLEVEL%

:use
powershell -NoProfile "%BASEDIR%\bin\Use.ps1" %*
exit /b %ERRORLEVEL%

:current
powershell -NoProfile "%BASEDIR%\bin\Current.ps1" %*
exit /b %ERRORLEVEL%

:ls
powershell -NoProfile "%BASEDIR%\bin\List.ps1" %*
exit /b %ERRORLEVEL%

:ls_remote
powershell -NoProfile "%BASEDIR%\bin\ListRemote.ps1" %*
exit /b %ERRORLEVEL%
