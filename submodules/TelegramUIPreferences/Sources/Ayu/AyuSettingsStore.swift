import Foundation

public final class AyuSettingsStore {
    public static let shared = AyuSettingsStore()

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let flagsKey = "ayugram.feature_flags.v1"
    private let designKey = "ayugram.design_settings.v1"
    private let firstLaunchAppliedKey = "ayugram.first_launch_applied.v1"

    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    public func featureFlags() -> AyuFeatureFlags {
        guard let data = self.defaults.data(forKey: self.flagsKey) else {
            return .default
        }
        return (try? self.decoder.decode(AyuFeatureFlags.self, from: data)) ?? .default
    }

    @discardableResult
    public func updateFeatureFlags(_ f: (inout AyuFeatureFlags) -> Void) -> AyuFeatureFlags {
        var value = self.featureFlags()
        f(&value)
        self.saveFeatureFlags(value)
        return value
    }

    public func saveFeatureFlags(_ flags: AyuFeatureFlags) {
        if let data = try? self.encoder.encode(flags) {
            self.defaults.set(data, forKey: self.flagsKey)
        }
    }

    public func designSettings() -> AyuDesignSettings {
        guard let data = self.defaults.data(forKey: self.designKey) else {
            return .default
        }
        return (try? self.decoder.decode(AyuDesignSettings.self, from: data)) ?? .default
    }

    @discardableResult
    public func updateDesignSettings(_ f: (inout AyuDesignSettings) -> Void) -> AyuDesignSettings {
        var value = self.designSettings()
        f(&value)
        self.saveDesignSettings(value)
        return value
    }

    public func saveDesignSettings(_ settings: AyuDesignSettings) {
        if let data = try? self.encoder.encode(settings) {
            self.defaults.set(data, forKey: self.designKey)
        }
    }

    public func shouldApplyDefaultDesignOnFirstLaunch() -> Bool {
        if self.defaults.bool(forKey: self.firstLaunchAppliedKey) {
            return false
        }
        return self.designSettings().defaultOnFirstLaunch
    }

    public func markDefaultDesignAppliedOnFirstLaunch() {
        self.defaults.set(true, forKey: self.firstLaunchAppliedKey)
    }
}
