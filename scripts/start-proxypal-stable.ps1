param(
  [string]$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
  [string]$BaseUrl = "http://127.0.0.1:8317/v1",
  [string]$Token = "proxypal-local",
  [string]$ProxyPalDir = "$env:LOCALAPPDATA\ProxyPal"
)

$ErrorActionPreference = "Stop"

$configPath = Join-Path $ProjectRoot "config\proxypal.local.yaml"
$cliPath = Join-Path $ProxyPalDir "cli-proxy-api.exe"
$logDir = Join-Path $ProjectRoot "logs"
$logPath = Join-Path $logDir "proxypal-stable-start.log"

if (-not (Test-Path -LiteralPath $logDir)) {
  New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Write-StartLog {
  param([string]$Message)
  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content -LiteralPath $logPath -Encoding UTF8 -Value "[$stamp] $Message"
}

function Test-ProxyAlive {
  try {
    $null = Invoke-WebRequest `
      -UseBasicParsing `
      -Uri "$BaseUrl/models" `
      -Headers @{ Authorization = "Bearer $Token" } `
      -TimeoutSec 10
    return $true
  } catch {
    return $false
  }
}

function Test-ConfigAliases {
  if (-not (Test-Path -LiteralPath $configPath)) { return $false }
  $text = Get-Content -LiteralPath $configPath -Encoding UTF8 -Raw
  return (
    $text -match "gemini-3-flash-claude" -and
    $text -match "gemini-3-flash-preview" -and
    $text -match "alias:\s*`"gemini-3-flash`""
  )
}

if (-not (Test-Path -LiteralPath $configPath)) {
  throw "Missing config\proxypal.local.yaml. Run scripts\setup.bat first."
}
if (-not (Test-Path -LiteralPath $cliPath)) {
  throw "ProxyPal CLI not found: $cliPath"
}

$current = Get-CimInstance Win32_Process -Filter "name = 'cli-proxy-api.exe'" -ErrorAction SilentlyContinue |
  Where-Object { $_.CommandLine -like "*$configPath*" }

if ($current -and (Test-ConfigAliases) -and (Test-ProxyAlive)) {
  Write-StartLog "ProxyPal stable bridge already alive."
  Write-Host "ProxyPal stable bridge already running on $BaseUrl"
  exit 0
}

Get-Process cli-proxy-api -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Start-Process $cliPath -ArgumentList @("-config", $configPath) -WindowStyle Hidden
Start-Sleep -Seconds 4

if (-not (Test-ProxyAlive)) {
  Write-StartLog "ERROR: ProxyPal stable bridge did not answer /models."
  throw "ProxyPal stable bridge did not answer /models."
}

Write-StartLog "ProxyPal stable bridge restarted OK."
Write-Host "ProxyPal stable bridge is running on $BaseUrl"
