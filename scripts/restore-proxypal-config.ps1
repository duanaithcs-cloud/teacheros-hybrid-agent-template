param(
  [string]$BackupPath = "$PSScriptRoot\..\_system_backup\proxypal.local.yaml.backup",
  [string]$TargetPath = "$PSScriptRoot\..\config\proxypal.local.yaml"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $BackupPath)) {
  throw "Backup not found: $BackupPath"
}

Copy-Item -LiteralPath $BackupPath -Destination $TargetPath -Force
Write-Host "Restored ProxyPal local config to: $TargetPath"

