param(
  [string]$BaseUrl = "http://127.0.0.1:8317/v1",
  [string]$Token = "proxypal-local"
)

$ErrorActionPreference = "Continue"

Write-Host "TeacherOS Hybrid Agent status"
Write-Host "Base URL: $BaseUrl"
Write-Host ""

$proc = Get-Process cli-proxy-api -ErrorAction SilentlyContinue
if ($proc) {
  Write-Host "[OK] ProxyPal CLI process is running."
} else {
  Write-Host "[WARN] ProxyPal CLI process is not running."
}

try {
  $res = Invoke-WebRequest -UseBasicParsing -Uri "$BaseUrl/models" -Headers @{ Authorization = "Bearer $Token" } -TimeoutSec 10
  Write-Host "[OK] /models returned HTTP $($res.StatusCode)."
  if ($res.Content -match "gemini") {
    Write-Host "[OK] Gemini models are visible through ProxyPal."
  }
} catch {
  Write-Host "[ERROR] Could not query ProxyPal: $($_.Exception.Message)"
}

