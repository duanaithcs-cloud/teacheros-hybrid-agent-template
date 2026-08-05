#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="$ROOT/config/proxypal.local.yaml"

if [ ! -f "$CONFIG" ]; then
  echo "[ERROR] Missing config/proxypal.local.yaml. Run scripts/setup.sh first."
  exit 1
fi

PROXYPAL_CLI="${PROXYPAL_CLI:-cli-proxy-api}"
if ! command -v "$PROXYPAL_CLI" >/dev/null 2>&1; then
  echo "[ERROR] ProxyPal CLI not found. Set PROXYPAL_CLI or install ProxyPal."
  exit 1
fi

pkill -f cli-proxy-api >/dev/null 2>&1 || true
"$PROXYPAL_CLI" -config "$CONFIG" >/tmp/teacheros-proxypal.log 2>&1 &
sleep 4

export ANTHROPIC_AUTH_TOKEN="proxypal-local"
export ANTHROPIC_BASE_URL="http://127.0.0.1:8317"
export ANTHROPIC_MODEL="gemini-3-flash-claude"
export ANTHROPIC_DEFAULT_HAIKU_MODEL="gemini-3-flash-claude"
export ANTHROPIC_DEFAULT_SONNET_MODEL="gemini-3-flash-claude"
export ANTHROPIC_DEFAULT_OPUS_MODEL="gemini-3-flash-claude"

cd "$ROOT"
claude --model gemini-3-flash-claude

