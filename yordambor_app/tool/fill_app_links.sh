#!/usr/bin/env bash
# Writes the release key's SHA-256 (Android) and the Apple Team ID (iOS)
# into the files that let shared links open the app, in web/.well-known
# and docs/.well-known. Both must then be served from
# https://yordambor.app/.well-known/ (and www.), with no redirect.
#
#   tool/fill_app_links.sh <APPLE_TEAM_ID> [PLAY_APP_SIGNING_SHA256]
#
# The upload key's SHA-256 comes from android/key.properties
# (tool/print_release_sha256.sh). With Play App Signing, apps installed from
# Google Play carry Google's key instead: pass its SHA-256 too (Play Console
# → Test and release → App integrity → App signing).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
team_id="${1:-}"
play_sha="${2:-}"
if [[ ! "$team_id" =~ ^[A-Z0-9]{10}$ ]]; then
  echo "Usage: tool/fill_app_links.sh <APPLE_TEAM_ID> (10 letters and digits)"
  exit 1
fi

sha="$("$ROOT/tool/print_release_sha256.sh" | tail -1 | tr -d '[:space:]')"
if [[ ! "$sha" =~ ^([0-9A-F]{2}:){31}[0-9A-F]{2}$ ]]; then
  echo "Could not read the release SHA-256 (got: $sha)"
  exit 1
fi

if [[ -n "$play_sha" && ! "$play_sha" =~ ^([0-9A-F]{2}:){31}[0-9A-F]{2}$ ]]; then
  echo "The Play signing SHA-256 should look like AB:CD:...(32 pairs)"
  exit 1
fi
fingerprints="\"$sha\""
if [[ -n "$play_sha" && "$play_sha" != "$sha" ]]; then
  fingerprints="$fingerprints, \"$play_sha\""
fi

for dir in "$ROOT/web/.well-known" "$ROOT/../docs/.well-known"; do
  mkdir -p "$dir"
  sed "s/\"REPLACE_WITH_RELEASE_SHA256_FINGERPRINT\"/$fingerprints/" \
    "$ROOT/web/.well-known/assetlinks.json" > "$dir/assetlinks.json.tmp"
  sed "s/REPLACE_WITH_APPLE_TEAM_ID/$team_id/" \
    "$ROOT/web/.well-known/apple-app-site-association" > "$dir/apple-app-site-association.tmp"
  mv "$dir/assetlinks.json.tmp" "$dir/assetlinks.json"
  mv "$dir/apple-app-site-association.tmp" "$dir/apple-app-site-association"
done
echo "Filled in. Serve web/.well-known (or docs/.well-known) at https://yordambor.app/.well-known/"
