#!/usr/bin/env bash
# Build the signed release bundle (.aab) for Google Play.
# Usage: tool/build_release_aab.sh [build_number]
#   build_number  Play's version code. Each upload to Play needs a bigger
#                 one than the last; without it, the number in pubspec.yaml
#                 (after the "+") is used.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="${HOME}/flutter/bin:${PATH}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found on PATH (expected at \$HOME/flutter/bin). Check your Flutter install."
  exit 1
fi

# Play only accepts bundles signed with the upload key.
if [[ ! -f android/key.properties ]]; then
  echo "Missing android/key.properties — copy android/key.properties.example and create a keystore:"
  echo "  keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload"
  exit 1
fi

# The Supabase settings: from .env.json (as for the emulator), or from
# SUPABASE_URL and SUPABASE_ANON_KEY in the environment.
DEFINES=()
if [[ -f .env.json ]]; then
  DEFINES+=(--dart-define-from-file=.env.json)
elif [[ -n "${SUPABASE_URL:-}" && -n "${SUPABASE_ANON_KEY:-}" ]]; then
  DEFINES+=(--dart-define=SUPABASE_URL="$SUPABASE_URL")
  DEFINES+=(--dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY")
else
  echo "Missing .env.json (or SUPABASE_URL and SUPABASE_ANON_KEY)."
  echo "  cp .env.json.example .env.json"
  echo "  # then paste your Supabase anon key"
  exit 1
fi

VERSION_LINE="$(grep -E '^version:' pubspec.yaml | head -1 | awk '{print $2}')"
VERSION_NAME="${VERSION_LINE%%+*}"
BUILD_NUMBER="${1:-${VERSION_LINE##*+}}"
if ! [[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]]; then
  echo "The build number must be a whole number, e.g.: tool/build_release_aab.sh 2"
  exit 1
fi

echo "Building YordamBor $VERSION_NAME (version code $BUILD_NUMBER)..."
flutter pub get
flutter build appbundle --release \
  --build-name="$VERSION_NAME" \
  --build-number="$BUILD_NUMBER" \
  "${DEFINES[@]}"

AAB="build/app/outputs/bundle/release/app-release.aab"
if [[ ! -f "$AAB" ]]; then
  echo "Build did not produce $AAB — check the output above for errors."
  exit 1
fi

echo
echo "DONE: $ROOT/$AAB"
echo "Version $VERSION_NAME, version code $BUILD_NUMBER."
echo "Upload it in Play Console (Test and release → your track → Create new release)."
echo "If Play says the version code is already used, run again with a bigger number:"
echo "  bash tool/build_release_aab.sh $((BUILD_NUMBER + 1))"

# Show the file in Finder.
if command -v open >/dev/null 2>&1; then
  open -R "$AAB" || true
fi
