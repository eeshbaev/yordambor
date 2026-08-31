#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [[ ! -f android/key.properties ]]; then
  echo "Missing android/key.properties — copy android/key.properties.example and create a keystore:"
  echo "  keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload"
  exit 1
fi

flutter build appbundle --release \
  --dart-define=SUPABASE_URL="${SUPABASE_URL:?Set SUPABASE_URL}" \
  --dart-define=SUPABASE_ANON_KEY="${SUPABASE_ANON_KEY:?Set SUPABASE_ANON_KEY}"

echo "AAB: build/app/outputs/bundle/release/app-release.aab"
