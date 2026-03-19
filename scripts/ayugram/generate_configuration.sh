#!/usr/bin/env bash
set -euo pipefail

# Generates a local configuration json for AyuGram iOS builds.
# Usage:
#   AYU_BUNDLE_ID=com.example.AyuGram \
#   AYU_API_ID=12345 \
#   AYU_API_HASH=xxxxxxxx \
#   AYU_TEAM_ID=TEAMID1234 \
#   ./scripts/ayugram/generate_configuration.sh

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
OUTPUT_PATH="${1:-$ROOT_DIR/build-system/ayugram-local-configuration.json}"

: "${AYU_BUNDLE_ID:?AYU_BUNDLE_ID is required}"
: "${AYU_API_ID:?AYU_API_ID is required}"
: "${AYU_API_HASH:?AYU_API_HASH is required}"
: "${AYU_TEAM_ID:?AYU_TEAM_ID is required}"

cat > "$OUTPUT_PATH" <<EOF
{
  "bundle_id": "${AYU_BUNDLE_ID}",
  "api_id": "${AYU_API_ID}",
  "api_hash": "${AYU_API_HASH}",
  "team_id": "${AYU_TEAM_ID}",
  "app_center_id": "0",
  "is_internal_build": "true",
  "is_appstore_build": "false",
  "appstore_id": "0",
  "app_specific_url_scheme": "ayugram",
  "premium_iap_product_id": "",
  "enable_siri": false,
  "enable_icloud": false
}
EOF

echo "Generated: $OUTPUT_PATH"
