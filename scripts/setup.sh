#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "TeacherOS Hybrid Agent - setup"

check_tool() {
  local label="$1"
  local cmd="$2"
  local url="$3"
  if command -v "$cmd" >/dev/null 2>&1; then
    echo "[OK] $label detected."
  else
    echo "[WARN] $label not found. Install from: $url"
  fi
}

check_tool "Cursor" "cursor" "https://www.cursor.com/"
check_tool "Node.js" "node" "https://nodejs.org/"
check_tool "Python" "python3" "https://www.python.org/downloads/"
check_tool "Claude Code CLI" "claude" "https://docs.anthropic.com/"

read -r -p "Paste your GOOGLE_AI_STUDIO_API_KEY: " GOOGLE_AI_STUDIO_API_KEY
if [ -z "$GOOGLE_AI_STUDIO_API_KEY" ]; then
  echo "[ERROR] API key is required."
  exit 1
fi

mkdir -p config _system_backup

cat > config/local.env <<EOF
GOOGLE_AI_STUDIO_API_KEY=$GOOGLE_AI_STUDIO_API_KEY
PROXYPAL_API_KEY=proxypal-local
OPENAI_BASE_URL=http://127.0.0.1:8317/v1
DEFAULT_MODEL=gemini-3-flash-claude
EOF

python3 - <<'PY'
from pathlib import Path
import os

root = Path.cwd()
key = Path("config/local.env").read_text(encoding="utf-8").split("GOOGLE_AI_STUDIO_API_KEY=", 1)[1].splitlines()[0]
tpl = Path("config/proxypal.config.example.yaml").read_text(encoding="utf-8")
Path("config/proxypal.local.yaml").write_text(tpl.replace("__GOOGLE_AI_STUDIO_API_KEY__", key), encoding="utf-8")
PY

cp config/proxypal.local.yaml _system_backup/proxypal.local.yaml.backup
cp .cursor/.cursorrules _system_backup/cursorrules.backup

echo "[OK] Generated local config. Run ./scripts/start-teacheros.sh next."

