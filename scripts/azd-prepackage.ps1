$ErrorActionPreference = 'Stop'

function Invoke-Flutter {
  param(
    [Parameter(Mandatory = $true)]
    [string[]]$Args
  )

  $flutterCmd = Get-Command flutter -ErrorAction SilentlyContinue
  if ($null -ne $flutterCmd) {
    & flutter @Args
    return
  }

  $puroCmd = Get-Command puro -ErrorAction SilentlyContinue
  if ($null -ne $puroCmd) {
    & puro flutter @Args
    return
  }

  throw "Flutter CLI not found. Install Flutter and add it to PATH, or install Puro so azd can run 'puro flutter'."
}

Invoke-Flutter -Args @('pub', 'get')
Invoke-Flutter -Args @('build', 'web', '--release')

Copy-Item -Path "web/staticwebapp.config.json" -Destination "build/web/staticwebapp.config.json" -Force
Write-Host "prepackage completed" -ForegroundColor Green
