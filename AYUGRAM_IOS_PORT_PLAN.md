# AyuGram iOS Port Plan

## Phase 1: Fork foundation

- [x] Telegram iOS source bootstrap
- [x] AyuGram build configuration templates
- [x] AyuGram local config generator script
- [x] IPA build instructions for macOS

## Phase 2: Minimum Ayu features

- [ ] Ayu settings section in app settings
- [ ] Feature flags storage (UserDefaults + migration)
- [ ] "Hide online" behavior controls
- [ ] Message history/anti-recall draft implementation
- [ ] Visual marks for edited/deleted messages

## Phase 3: Advanced features

- [ ] Filters (ads/service messages)
- [ ] Streamer mode
- [ ] UI customizations (font/style options)

## Implementation approach

1. Add a dedicated `Ayu` namespace in source code.
2. Keep each feature behind one flag (easy disable and testing).
3. Port features in small PR-size chunks.
4. Verify each feature on TestFlight or sideload build before next step.
