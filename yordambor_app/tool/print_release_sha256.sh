#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PROPS="$ROOT/android/key.properties"

if [[ ! -f "$PROPS" ]]; then
  echo "Missing android/key.properties"
  exit 1
fi

store_file="$(grep '^storeFile=' "$PROPS" | cut -d= -f2-)"
store_password="$(grep '^storePassword=' "$PROPS" | cut -d= -f2-)"
key_alias="$(grep '^keyAlias=' "$PROPS" | cut -d= -f2-)"

if [[ -z "$store_file" || -z "$store_password" || -z "$key_alias" ]]; then
  echo "key.properties must set storeFile, storePassword, and keyAlias"
  exit 1
fi

keystore="$ROOT/android/$store_file"
if [[ ! -f "$keystore" ]]; then
  keystore="$ROOT/$store_file"
fi

if [[ ! -f "$keystore" ]]; then
  echo "Keystore not found: $store_file"
  exit 1
fi

echo "Release SHA-256 (paste into web/.well-known/assetlinks.json):"
keytool -list -v -keystore "$keystore" -alias "$key_alias" -storepass "$store_password" \
  | awk -F': ' '/SHA256:/ {print $2}'
