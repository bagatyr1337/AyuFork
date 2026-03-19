#!/usr/bin/env bash
set -euo pipefail

# Build AyuGram iOS IPA for sideload / ESign workflow.
#
# Required env:
#   AYU_BUNDLE_ID   e.g. com.yourname.AyuGram
#   AYU_API_ID      from https://my.telegram.org/apps
#   AYU_API_HASH    from https://my.telegram.org/apps
#   AYU_TEAM_ID     Apple Team ID (for xcode-managed signing)
#
# Optional env:
#   AYU_BUILD_NUMBER (default: 100001)
#   AYU_OUTPUT_DIR   (default: "$HOME/ayugram-build-artifacts")
#   AYU_CACHE_DIR    (default: "$HOME/telegram-bazel-cache")

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

: "${AYU_BUNDLE_ID:?AYU_BUNDLE_ID is required}"
: "${AYU_API_ID:?AYU_API_ID is required}"
: "${AYU_API_HASH:?AYU_API_HASH is required}"
: "${AYU_TEAM_ID:?AYU_TEAM_ID is required}"

AYU_BUILD_NUMBER="${AYU_BUILD_NUMBER:-100001}"
AYU_OUTPUT_DIR="${AYU_OUTPUT_DIR:-$HOME/ayugram-build-artifacts}"
AYU_CACHE_DIR="${AYU_CACHE_DIR:-$HOME/telegram-bazel-cache}"
AYU_CONFIG_PATH="$ROOT_DIR/build-system/ayugram-local-configuration.json"

mkdir -p "$AYU_OUTPUT_DIR"

cd "$ROOT_DIR"

echo "[1/3] Generating Ayu config..."
AYU_BUNDLE_ID="$AYU_BUNDLE_ID" \
AYU_API_ID="$AYU_API_ID" \
AYU_API_HASH="$AYU_API_HASH" \
AYU_TEAM_ID="$AYU_TEAM_ID" \
"$ROOT_DIR/scripts/ayugram/generate_configuration.sh" "$AYU_CONFIG_PATH"

echo "[2/3] Generating Xcode project (xcode-managed signing)..."
python3 build-system/Make/Make.py \
  --cacheDir="$AYU_CACHE_DIR" \
  generateProject \
  --configurationPath="$AYU_CONFIG_PATH" \
  --xcodeManagedCodesigning

echo "[3/3] Building release_arm64 IPA..."
python3 build-system/Make/Make.py \
  --cacheDir="$AYU_CACHE_DIR" \
  build \
  --configurationPath="$AYU_CONFIG_PATH" \
  --xcodeManagedCodesigning \
  --buildNumber="$AYU_BUILD_NUMBER" \
  --configuration=release_arm64 \
  --outputBuildArtifactsPath="$AYU_OUTPUT_DIR"

echo "Done."
echo "IPA path: $AYU_OUTPUT_DIR/Telegram.ipa"
