#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="${HOME}/flutter/bin:${PATH}"

ENV_FILE="$ROOT/.env.json"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing .env.json"
  echo "  cp .env.json.example .env.json"
  echo "  # then paste your Supabase anon key"
  exit 1
fi

exec flutter run --dart-define-from-file=.env.json "$@"
