# nvmp

nvmp is a Node Version Manager implemented by Powershell

- Supports PowerShell **v2**
- No Administrator privileges required
- Respects proxy settings of Internet Options

# Usage
```
PS C:\> nvmp
Node Version Manager by Powershell

Usage:
  nvmp help                       : Show this message
  nvmp install <version> [arch]   : Download and install the specified version of node.js.
                                    Optionally specify whether to install the "x86" or "x64" version (defaults to system arch).
  nvmp uninstall <version> [arch] : Uninstall the specified version of node.js
  nvmp use <version> [arch]       : Switch to use the specified version. Optionally specify x86/x64 architecture.
  nvmp current                    : Show current in-use version of node.js
  nvmp ls                         : List the node.js installations.
  nvmp ls-remote                  : List the installable versions

Example:
  nvmp install v10.9.0     : Install a specific version number of node.js
  nvmp install v10.9.0 x86 : Install a 32-bit version
  nvmp use v10.9.0         : Use the specific version
```

# Installation

Add the path to nvmp directory and current version directory to your PATH environment variable.

```powershell
PS C:\git> git clone https://github.com/clomie/nvmp 
PS C:\git> $Path = [environment]::getEnvironmentVariable('PATH', 'User')
PS C:\git> $Path = "$ENV:USERPROFILE\.nvmp\current;C:\git\nvmp;$Path"
PS C:\git> [environment]::setEnvironmentVariable('PATH', $Path, 'User')
```

And then, restart your powershell.
