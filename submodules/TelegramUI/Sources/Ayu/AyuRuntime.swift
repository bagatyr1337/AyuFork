import Foundation
import TelegramUIPreferences

public enum AyuRuntime {
    public static func featureFlags() -> AyuFeatureFlags {
        return AyuSettingsStore.shared.featureFlags()
    }

    public static func designSettings() -> AyuDesignSettings {
        return AyuSettingsStore.shared.designSettings()
    }

    public static func shouldSendReadAcknowledgements() -> Bool {
        return !featureFlags().manualReadAckEnabled
    }

    public static func isGhostModeActive() -> Bool {
        return featureFlags().ghostModeEnabled
    }

    public static func isAntiRecallEnabled() -> Bool {
        return featureFlags().antiRecallEnabled
    }

    public static func historyStore() -> AyuHistoryStore {
        return AyuHistoryStore.shared
    }
}
