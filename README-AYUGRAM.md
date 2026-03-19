# AyuGram iOS Fork Bootstrap

This folder is a fork base of `TelegramMessenger/Telegram-iOS` prepared for
an AyuGram-style iOS client.

## What is already prepared

- `build-system/template_ayugram_development_configuration.json`
- `build-system/template_ayugram_release_configuration.json`
- `scripts/ayugram/generate_configuration.sh`

## Build an IPA on macOS

1. Copy the repository to macOS with Xcode installed.
2. Create config:

```bash
cd Telegram-iOS
AYU_BUNDLE_ID=com.yourname.AyuGram \
AYU_API_ID=123456 \
AYU_API_HASH=your_api_hash \
AYU_TEAM_ID=YOURTEAMID \
./scripts/ayugram/generate_configuration.sh
```

3. Generate project:

```bash
python3 build-system/Make/Make.py \
  --cacheDir="$HOME/telegram-bazel-cache" \
  generateProject \
  --configurationPath=build-system/ayugram-local-configuration.json \
  --xcodeManagedCodesigning
```

4. Build release IPA (distribution profiles required):

```bash
python3 build-system/Make/Make.py \
  --cacheDir="$HOME/telegram-bazel-cache" \
  build \
  --configurationPath=build-system/ayugram-local-configuration.json \
  --codesigningInformationPath=/path/to/codesigning-data \
  --buildNumber=100001 \
  --configuration=release_arm64
```

## Notes

- iPhone `.ipa` can only be signed and produced on macOS/Xcode.
- Android `.apk` cannot be converted into iOS `.ipa`.
- This bootstrap is intended to start a real fork and then port AyuGram
  features one by one.

## ESign

For a practical RU guide (build + install through ESign), see:

- `docs/ESIGN_INSTALL_RU.md`
- `scripts/ayugram/build_ipa_for_esign.sh`

No Mac? Use GitHub Actions cloud build:

- `docs/NO_MAC_BUILD_RU.md`
- `.github/workflows/ayugram-ipa.yml`
