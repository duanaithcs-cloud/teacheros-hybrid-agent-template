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
$logPath = Join-Path $logDir "proxypal-watchdog.log"

if (-not (Test-Path -LiteralPath $logDir)) {
  New-Item -ItemType Directory -Path $logDir -Force | Out-Null
}

function Write-WatchdogLog {
  param([string]$Message)
  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  Add-Content -LiteralPath $logPath -Encoding UTF8 -Value "[$stamp] $Message"
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

function Restart-ProxyPal {
  if (-not (Test-Path -LiteralPath $configPath)) {
    throw "Missing config\proxypal.local.yaml. Run scripts\setup.bat first."
  }
  if (-not (Test-Path -LiteralPath $cliPath)) {
    throw "ProxyPal CLI not found: $cliPath"
  }

  Get-Process cli-proxy-api -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2
  Start-Process $cliPath -ArgumentList @("-config", $configPath) -WindowStyle Hidden
  Start-Sleep -Seconds 4
  Write-WatchdogLog "Restarted ProxyPal with project local config."
}

try {
  $proc = Get-CimInstance Win32_Process -Filter "name = 'cli-proxy-api.exe'" -ErrorAction SilentlyContinue |
    Where-Object { $_.CommandLine -like "*$configPath*" }

  $aliasesOk = Test-ConfigAliases
  $proxyAlive = Test-ProxyAlive

  if ($proc -and $aliasesOk -and $proxyAlive) {
    Write-WatchdogLog "OK"
    exit 0
  }

  Write-WatchdogLog "Repair needed. Proc=$([bool]$proc); Aliases=$aliasesOk; Alive=$proxyAlive"
  Restart-ProxyPal

  if (Test-ProxyAlive) {
    Write-WatchdogLog "Repair OK"
    exit 0
  }

  Write-WatchdogLog "Repair failed: ProxyPal did not answer /models."
  exit 1
} catch {
  Write-WatchdogLog "ERROR: $($_.Exception.Message)"
  exit 1
}

