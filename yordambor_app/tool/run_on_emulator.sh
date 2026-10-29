#!/usr/bin/env bash
# Build YordamBor, install it on a booted Android emulator, and launch it.
# Usage: tool/run_on_emulator.sh [--fresh] [--reset] [--debug] [avd_name]
#   --fresh     flutter clean before building
#   --reset     clear the app's data on the emulator first, so it starts
#               like a new install (the introduction shows again; you will
#               need to sign in again)
#   --debug     a debug build instead of the default profile build. Profile
#               builds run like the store version, so motion is smooth;
#               debug builds stutter and are only for debugging.
#   avd_name    specific AVD to boot if none is already running
#               (otherwise the first one `flutter emulators` lists is used)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

export PATH="${HOME}/flutter/bin:${PATH}"
export ANDROID_HOME="${ANDROID_HOME:-$HOME/Library/Android/sdk}"
export ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-$ANDROID_HOME}"
export PATH="${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator:${PATH}"

PACKAGE="uz.yordambor.yordambor"
ACTIVITY=".MainActivity"

ENV_FILE="$ROOT/.env.json"
if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing .env.json"
  echo "  cp .env.json.example .env.json"
  echo "  # then paste your Supabase anon key"
  exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
  echo "flutter not found on PATH (expected at \$HOME/flutter/bin). Check your Flutter install."
  exit 1
fi

if ! command -v adb >/dev/null 2>&1; then
  echo "adb not found on PATH (expected under \$ANDROID_HOME/platform-tools). Check your Android SDK install."
  exit 1
fi

FRESH=""
RESET=""
MODE="profile"
AVD_ARG=""
for arg in "$@"; do
  if [[ "$arg" == "--fresh" ]]; then
    FRESH="1"
  elif [[ "$arg" == "--reset" ]]; then
    RESET="1"
  elif [[ "$arg" == "--debug" ]]; then
    MODE="debug"
  else
    AVD_ARG="$arg"
  fi
done

if [[ -n "$FRESH" ]]; then
  echo "Cleaning previous build..."
  flutter clean
fi

# 1. Make sure an emulator is up
DEVICE_ID="$(adb devices | awk '$2=="device" {print $1; exit}')"
if [[ -z "$DEVICE_ID" ]]; then
  echo "No running emulator found. Looking for an AVD to boot..."
  AVD_NAME="$AVD_ARG"
  if [[ -z "$AVD_NAME" ]]; then
    AVD_NAME="$(flutter emulators | awk -F' *• *' 'NR>2 && NF>1 {print $1; exit}')"
  fi
  if [[ -z "$AVD_NAME" ]]; then
    echo "No AVD configured. Create one in Android Studio (Device Manager) or pass its id as an argument, then re-run."
    echo "Available emulators:"
    flutter emulators || true
    exit 1
  fi
  echo "Booting emulator: $AVD_NAME (this can take a minute the first time)..."
  flutter emulators --launch "$AVD_NAME"
  echo "Waiting for it to come online..."
  adb wait-for-device
  for i in $(seq 1 60); do
    BOOTED="$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" || true
    if [[ "$BOOTED" == "1" ]]; then
      break
    fi
    sleep 5
  done
  DEVICE_ID="$(adb devices | awk '$2=="device" {print $1; exit}')"
  if [[ -z "$DEVICE_ID" ]]; then
    echo "Emulator did not come online in time. Check the emulator window and re-run."
    exit 1
  fi
fi
echo "Using device: $DEVICE_ID"

# 2. Install packages
echo "Installing packages (flutter pub get)..."
flutter pub get

# 3. Build the stand-alone app, only for this emulator's processor
#    (first time takes a few minutes)
ABI="$(adb -s "$DEVICE_ID" shell getprop ro.product.cpu.abi 2>/dev/null | tr -d '\r')"
case "$ABI" in
  arm64-v8a) TARGET="android-arm64" ;;
  x86_64) TARGET="android-x64" ;;
  armeabi-v7a) TARGET="android-arm" ;;
  *) TARGET="" ;;
esac
BUILD_ARGS=(--"$MODE" --dart-define-from-file=.env.json)
if [[ -n "$TARGET" ]]; then
  BUILD_ARGS+=(--target-platform "$TARGET")
fi
echo "Building the stand-alone app ($MODE, first time takes a few minutes)..."
flutter build apk "${BUILD_ARGS[@]}"

APK="build/app/outputs/flutter-apk/app-$MODE.apk"
if [[ ! -f "$APK" ]]; then
  echo "Build did not produce $APK — check the output above for errors."
  exit 1
fi

# 4. Install + launch
echo "Installing on $DEVICE_ID..."
if ! adb -s "$DEVICE_ID" install -r "$APK"; then
  echo "Install failed — if this is a signature mismatch from an earlier build, try:"
  echo "  adb -s $DEVICE_ID uninstall $PACKAGE"
  exit 1
fi

if [[ -n "$RESET" ]]; then
  echo "Clearing the app's data, as for a new install..."
  adb -s "$DEVICE_ID" shell pm clear "$PACKAGE" >/dev/null || true
fi

echo "Launching a fresh instance of $PACKAGE..."
adb -s "$DEVICE_ID" shell am start -S -n "$PACKAGE/$ACTIVITY"

echo "App opened. Waiting 20 seconds..."
sleep 20

echo
echo "DONE. Tell Claude 'done'."
