param(
  [Parameter(Mandatory = $true)]
  [string]$Hostname,

  [Parameter(Mandatory = $false)]
  [ValidateSet('cname-delegation', 'dns-txt-token')]
  [string]$ValidationMethod = 'cname-delegation',

  [Parameter(Mandatory = $false)]
  [string]$ResourceGroup = 'rg-OOdapNotes',

  [Parameter(Mandatory = $false)]
  [string]$StaticWebAppName = 'swa-oodapnotes-fwvanl'
)

$ErrorActionPreference = 'Stop'

Write-Host "[1/2] Setting custom domain '$Hostname' on '$StaticWebAppName'..." -ForegroundColor Cyan
az staticwebapp hostname set `
  --resource-group $ResourceGroup `
  --name $StaticWebAppName `
  --hostname $Hostname `
  --validation-method $ValidationMethod

Write-Host "[2/2] Checking hostname status..." -ForegroundColor Cyan
az staticwebapp hostname show `
  --resource-group $ResourceGroup `
  --name $StaticWebAppName `
  --hostname $Hostname `
  -o table

Write-Host "Done. If status is pending, verify DNS records and retry this script." -ForegroundColor Green
