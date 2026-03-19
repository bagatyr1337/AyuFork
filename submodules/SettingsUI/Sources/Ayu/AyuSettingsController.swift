import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import TelegramUIPreferences
import ItemListUI
import PresentationDataUtils
import AccountContext

private final class AyuSettingsControllerArguments {
    let toggleFlag: ((inout AyuFeatureFlags) -> Void) -> Void
    let cyclePreset: () -> Void
    let cycleFontProfile: () -> Void
    let cycleAnimationLevel: () -> Void
    let cycleBubbleStyle: () -> Void
    let cycleBackgroundStyle: () -> Void
    let applyDesignNow: () -> Void
    let clearHistory: () -> Void
    let resetAll: () -> Void

    init(
        toggleFlag: @escaping (((inout AyuFeatureFlags) -> Void) -> Void),
        cyclePreset: @escaping () -> Void,
        cycleFontProfile: @escaping () -> Void,
        cycleAnimationLevel: @escaping () -> Void,
        cycleBubbleStyle: @escaping () -> Void,
        cycleBackgroundStyle: @escaping () -> Void,
        applyDesignNow: @escaping () -> Void,
        clearHistory: @escaping () -> Void,
        resetAll: @escaping () -> Void
    ) {
        self.toggleFlag = toggleFlag
        self.cyclePreset = cyclePreset
        self.cycleFontProfile = cycleFontProfile
        self.cycleAnimationLevel = cycleAnimationLevel
        self.cycleBubbleStyle = cycleBubbleStyle
        self.cycleBackgroundStyle = cycleBackgroundStyle
        self.applyDesignNow = applyDesignNow
        self.clearHistory = clearHistory
        self.resetAll = resetAll
    }
}

private enum AyuSettingsSection: Int32 {
    case features
    case design
    case storage
}

private enum AyuSettingsEntry: ItemListNodeEntry {
    case featuresHeader(PresentationTheme, String)
    case ghostMode(PresentationTheme, String, Bool)
    case manualReadAck(PresentationTheme, String, Bool)
    case antiRecall(PresentationTheme, String, Bool)
    case history(PresentationTheme, String, Bool)
    case streamerMode(PresentationTheme, String, Bool)
    case messageFilters(PresentationTheme, String, Bool)
    case customMarks(PresentationTheme, String, Bool)
    case riskyInfo(PresentationTheme, String)

    case designHeader(PresentationTheme, String)
    case preset(PresentationTheme, String, String)
    case fontProfile(PresentationTheme, String, String)
    case animationLevel(PresentationTheme, String, String)
    case bubbleStyle(PresentationTheme, String, String)
    case backgroundStyle(PresentationTheme, String, String)
    case applyDesign(PresentationTheme, String)
    case designInfo(PresentationTheme, String)

    case storageHeader(PresentationTheme, String)
    case historyCount(PresentationTheme, String, String)
    case clearHistory(PresentationTheme, String)
    case resetAll(PresentationTheme, String)

    var section: ItemListSectionId {
        switch self {
        case .featuresHeader, .ghostMode, .manualReadAck, .antiRecall, .history, .streamerMode, .messageFilters, .customMarks, .riskyInfo:
            return AyuSettingsSection.features.rawValue
        case .designHeader, .preset, .fontProfile, .animationLevel, .bubbleStyle, .backgroundStyle, .applyDesign, .designInfo:
            return AyuSettingsSection.design.rawValue
        case .storageHeader, .historyCount, .clearHistory, .resetAll:
            return AyuSettingsSection.storage.rawValue
        }
    }

    var stableId: Int32 {
        switch self {
        case .featuresHeader:
            return 0
        case .ghostMode:
            return 1
        case .manualReadAck:
            return 2
        case .antiRecall:
            return 3
        case .history:
            return 4
        case .streamerMode:
            return 5
        case .messageFilters:
            return 6
        case .customMarks:
            return 7
        case .riskyInfo:
            return 8
        case .designHeader:
            return 20
        case .preset:
            return 21
        case .fontProfile:
            return 22
        case .animationLevel:
            return 23
        case .bubbleStyle:
            return 24
        case .backgroundStyle:
            return 25
        case .applyDesign:
            return 26
        case .designInfo:
            return 27
        case .storageHeader:
            return 40
        case .historyCount:
            return 41
        case .clearHistory:
            return 42
        case .resetAll:
            return 43
        }
    }

    static func <(lhs: AyuSettingsEntry, rhs: AyuSettingsEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }

    static func ==(lhs: AyuSettingsEntry, rhs: AyuSettingsEntry) -> Bool {
        switch lhs {
        case let .featuresHeader(lhsTheme, lhsText):
            if case let .featuresHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        case let .ghostMode(lhsTheme, lhsText, lhsValue):
            if case let .ghostMode(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .manualReadAck(lhsTheme, lhsText, lhsValue):
            if case let .manualReadAck(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .antiRecall(lhsTheme, lhsText, lhsValue):
            if case let .antiRecall(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .history(lhsTheme, lhsText, lhsValue):
            if case let .history(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .streamerMode(lhsTheme, lhsText, lhsValue):
            if case let .streamerMode(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .messageFilters(lhsTheme, lhsText, lhsValue):
            if case let .messageFilters(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .customMarks(lhsTheme, lhsText, lhsValue):
            if case let .customMarks(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .riskyInfo(lhsTheme, lhsText):
            if case let .riskyInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        case let .designHeader(lhsTheme, lhsText):
            if case let .designHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        case let .preset(lhsTheme, lhsText, lhsValue):
            if case let .preset(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .fontProfile(lhsTheme, lhsText, lhsValue):
            if case let .fontProfile(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .animationLevel(lhsTheme, lhsText, lhsValue):
            if case let .animationLevel(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .bubbleStyle(lhsTheme, lhsText, lhsValue):
            if case let .bubbleStyle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .backgroundStyle(lhsTheme, lhsText, lhsValue):
            if case let .backgroundStyle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .applyDesign(lhsTheme, lhsText):
            if case let .applyDesign(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        case let .designInfo(lhsTheme, lhsText):
            if case let .designInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        case let .storageHeader(lhsTheme, lhsText):
            if case let .storageHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        case let .historyCount(lhsTheme, lhsText, lhsValue):
            if case let .historyCount(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
        case let .clearHistory(lhsTheme, lhsText):
            if case let .clearHistory(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        case let .resetAll(lhsTheme, lhsText):
            if case let .resetAll(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
        }
        return false
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let arguments = arguments as! AyuSettingsControllerArguments
        switch self {
        case let .featuresHeader(_, text), let .designHeader(_, text), let .storageHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .ghostMode(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                arguments.toggleFlag({ $0.ghostModeEnabled = v })
            })
        case let .manualReadAck(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                arguments.toggleFlag({ $0.manualReadAckEnabled = v })
            })
        case let .antiRecall(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                arguments.toggleFlag({ $0.antiRecallEnabled = v })
            })
        case let .history(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                arguments.toggleFlag({ $0.historyEnabled = v })
            })
        case let .streamerMode(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                arguments.toggleFlag({ $0.streamerModeEnabled = v })
            })
        case let .messageFilters(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                arguments.toggleFlag({ $0.messageFiltersEnabled = v })
            })
        case let .customMarks(_, title, value):
            return ItemListSwitchItem(presentationData: presentationData, systemStyle: .glass, title: title, value: value, sectionId: self.section, style: .blocks, updated: { v in
                arguments.toggleFlag({ $0.customMarksEnabled = v })
            })
        case let .riskyInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        case let .preset(_, title, value):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: value, labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.cyclePreset()
            })
        case let .fontProfile(_, title, value):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: value, labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.cycleFontProfile()
            })
        case let .animationLevel(_, title, value):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: value, labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.cycleAnimationLevel()
            })
        case let .bubbleStyle(_, title, value):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: value, labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.cycleBubbleStyle()
            })
        case let .backgroundStyle(_, title, value):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: value, labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.cycleBackgroundStyle()
            })
        case let .applyDesign(_, title):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: "", labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.applyDesignNow()
            })
        case let .designInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        case let .historyCount(_, title, value):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: value, labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .none, action: {})
        case let .clearHistory(_, title):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: "", labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.clearHistory()
            })
        case let .resetAll(_, title):
            return ItemListDisclosureItem(presentationData: presentationData, systemStyle: .glass, title: title, label: "", labelStyle: .text, sectionId: self.section, style: .blocks, disclosureStyle: .arrow, action: {
                arguments.resetAll()
            })
        }
    }
}

private func ayuDisplayName(preset: AyuDesignPreset) -> String {
    switch preset {
    case .ayuOcean:
        return "Ayu Ocean"
    case .ayuDark:
        return "Ayu Dark"
    case .ayuClassic:
        return "Ayu Classic"
    }
}

private func ayuDisplayName(fontProfile: AyuFontProfile) -> String {
    switch fontProfile {
    case .system:
        return "System"
    case .compact:
        return "Compact"
    case .readable:
        return "Readable"
    }
}

private func ayuDisplayName(animationLevel: AyuAnimationLevel) -> String {
    switch animationLevel {
    case .off:
        return "Off"
    case .standard:
        return "Standard"
    case .enhanced:
        return "Enhanced"
    }
}

private func ayuNextPreset(_ current: AyuDesignPreset) -> AyuDesignPreset {
    switch current {
    case .ayuOcean:
        return .ayuDark
    case .ayuDark:
        return .ayuClassic
    case .ayuClassic:
        return .ayuOcean
    }
}

private func ayuNextFontProfile(_ current: AyuFontProfile) -> AyuFontProfile {
    switch current {
    case .system:
        return .compact
    case .compact:
        return .readable
    case .readable:
        return .system
    }
}

private func ayuNextAnimationLevel(_ current: AyuAnimationLevel) -> AyuAnimationLevel {
    switch current {
    case .off:
        return .standard
    case .standard:
        return .enhanced
    case .enhanced:
        return .off
    }
}

private func ayuNextStyle(_ current: String, values: [String]) -> String {
    guard let index = values.firstIndex(of: current) else {
        return values.first ?? current
    }
    let next = (index + 1) % values.count
    return values[next]
}

private func ayuDefaultAccent(for preset: AyuDesignPreset) -> UInt32? {
    switch preset {
    case .ayuOcean:
        return 0x2b88ff
    case .ayuDark:
        return 0x54d2ff
    case .ayuClassic:
        return nil
    }
}

private func ayuBubbleColors(for preset: AyuDesignPreset) -> [UInt32] {
    switch preset {
    case .ayuOcean:
        return [0xbfe4ff, 0x8dd0ff]
    case .ayuDark:
        return [0x3b6f8f, 0x2f5f7d]
    case .ayuClassic:
        return []
    }
}

private func ayuBubbleSettings(for style: String) -> PresentationChatBubbleSettings {
    switch style {
    case "compact":
        return PresentationChatBubbleSettings(mainRadius: 12, auxiliaryRadius: 6, mergeBubbleCorners: true)
    case "square":
        return PresentationChatBubbleSettings(mainRadius: 6, auxiliaryRadius: 4, mergeBubbleCorners: false)
    default:
        return PresentationChatBubbleSettings(mainRadius: 16, auxiliaryRadius: 8, mergeBubbleCorners: true)
    }
}

private func applyAyuRuntimeSettings(context: AccountContext, flags: AyuFeatureFlags, design: AyuDesignSettings) {
    let _ = updateExperimentalUISettingsInteractively(accountManager: context.sharedContext.accountManager, { current in
        var current = current
        current.skipReadHistory = flags.manualReadAckEnabled
        current.disableBackgroundAnimation = design.animationLevel == .off
        return current
    }).start()
}

func ayuApplyDesign(context: AccountContext, design: AyuDesignSettings) {
    let _ = updatePresentationThemeSettingsInteractively(accountManager: context.sharedContext.accountManager, { current in
        let themeReference: PresentationThemeReference
        switch design.preset {
        case .ayuOcean:
            themeReference = .builtin(.day)
        case .ayuDark:
            themeReference = .builtin(.nightAccent)
        case .ayuClassic:
            themeReference = .builtin(.dayClassic)
        }

        var updated = current.withUpdatedTheme(themeReference)

        let resolvedAccent = design.accentColor ?? ayuDefaultAccent(for: design.preset)
        var accentColors = updated.themeSpecificAccentColors
        if let resolvedAccent {
            let accentIndex = 9000 + Int32(truncatingIfNeeded: themeReference.index & Int64(0x7fff))
            let accent = PresentationThemeAccentColor(index: accentIndex, baseColor: .custom, accentColor: resolvedAccent, bubbleColors: ayuBubbleColors(for: design.preset))
            accentColors[themeReference.index] = accent
        } else {
            accentColors.removeValue(forKey: themeReference.index)
        }
        updated = updated.withUpdatedThemeSpecificAccentColors(accentColors)

        switch design.fontProfile {
        case .system:
            updated = updated.withUpdatedUseSystemFont(true)
        case .compact:
            updated = updated.withUpdatedUseSystemFont(false).withUpdatedFontSizes(fontSize: .small, listsFontSize: .small)
        case .readable:
            updated = updated.withUpdatedUseSystemFont(false).withUpdatedFontSizes(fontSize: .large, listsFontSize: .large)
        }

        updated = updated.withUpdatedReduceMotion(design.animationLevel == .off)
        updated = updated.withUpdatedChatBubbleSettings(ayuBubbleSettings(for: design.bubbleStyle))

        var wallpapers = updated.themeSpecificChatWallpapers
        switch design.chatBackgroundStyle {
        case "solid":
            wallpapers[themeReference.index] = .color(0xdcefff)
        case "gradient":
            wallpapers[themeReference.index] = .gradient(TelegramWallpaper.Gradient(id: nil, colors: [0xdcefff, 0xf3fbff], settings: WallpaperSettings()))
        default:
            wallpapers.removeValue(forKey: themeReference.index)
        }
        updated = updated.withUpdatedThemeSpecificChatWallpapers(wallpapers)

        return updated
    }).start()
}

public func ayuApplyDefaultDesignIfNeeded(context: AccountContext) {
    if AyuSettingsStore.shared.shouldApplyDefaultDesignOnFirstLaunch() {
        let design = AyuSettingsStore.shared.designSettings()
        ayuApplyDesign(context: context, design: design)
        applyAyuRuntimeSettings(context: context, flags: AyuSettingsStore.shared.featureFlags(), design: design)
        AyuSettingsStore.shared.markDefaultDesignAppliedOnFirstLaunch()
    }
}

public func ayuSyncRuntimeSettings(context: AccountContext) {
    applyAyuRuntimeSettings(
        context: context,
        flags: AyuSettingsStore.shared.featureFlags(),
        design: AyuSettingsStore.shared.designSettings()
    )
}

private func ayuSettingsEntries(
    presentationData: PresentationData,
    flags: AyuFeatureFlags,
    design: AyuDesignSettings,
    historyCount: Int
) -> [AyuSettingsEntry] {
    var entries: [AyuSettingsEntry] = []

    entries.append(.featuresHeader(presentationData.theme, "AYUGRAM FEATURES"))
    entries.append(.ghostMode(presentationData.theme, "Ghost Mode", flags.ghostModeEnabled))
    entries.append(.manualReadAck(presentationData.theme, "Manual Read Ack", flags.manualReadAckEnabled))
    entries.append(.antiRecall(presentationData.theme, "Anti-recall", flags.antiRecallEnabled))
    entries.append(.history(presentationData.theme, "History", flags.historyEnabled))
    entries.append(.streamerMode(presentationData.theme, "Streamer Mode", flags.streamerModeEnabled))
    entries.append(.messageFilters(presentationData.theme, "Message Filters", flags.messageFiltersEnabled))
    entries.append(.customMarks(presentationData.theme, "Custom Edited/Deleted Marks", flags.customMarksEnabled))
    entries.append(.riskyInfo(presentationData.theme, "Risky features are safe-by-default and remain OFF until enabled manually."))

    entries.append(.designHeader(presentationData.theme, "AYUGRAM DESIGN"))
    entries.append(.preset(presentationData.theme, "Preset", ayuDisplayName(preset: design.preset)))
    entries.append(.fontProfile(presentationData.theme, "Font Profile", ayuDisplayName(fontProfile: design.fontProfile)))
    entries.append(.animationLevel(presentationData.theme, "Animation Level", ayuDisplayName(animationLevel: design.animationLevel)))
    entries.append(.bubbleStyle(presentationData.theme, "Bubble Style", design.bubbleStyle.capitalized))
    entries.append(.backgroundStyle(presentationData.theme, "Chat Background", design.chatBackgroundStyle.capitalized))
    entries.append(.applyDesign(presentationData.theme, "Apply Ayu Design Now"))
    entries.append(.designInfo(presentationData.theme, "Default preset is Ayu Ocean. Design changes are applied to Telegram theme settings immediately."))

    entries.append(.storageHeader(presentationData.theme, "AYUGRAM STORAGE"))
    entries.append(.historyCount(presentationData.theme, "Saved Records", "\(historyCount)"))
    entries.append(.clearHistory(presentationData.theme, "Clear Local History"))
    entries.append(.resetAll(presentationData.theme, "Reset Ayu Flags + Design"))

    return entries
}

public func ayuSettingsController(context: AccountContext) -> ViewController {
    let refreshToken = ValuePromise<Int>(0, ignoreRepeated: false)
    let refreshTokenValue = Atomic<Int>(value: 0)
    let updateRefresh: () -> Void = {
        refreshToken.set(refreshTokenValue.modify { $0 + 1 })
    }

    ayuApplyDefaultDesignIfNeeded(context: context)

    let arguments = AyuSettingsControllerArguments(
        toggleFlag: { updater in
            let flags = AyuSettingsStore.shared.updateFeatureFlags(updater)
            applyAyuRuntimeSettings(context: context, flags: flags, design: AyuSettingsStore.shared.designSettings())
            updateRefresh()
        },
        cyclePreset: {
            let design = AyuSettingsStore.shared.updateDesignSettings { current in
                current.preset = ayuNextPreset(current.preset)
            }
            ayuApplyDesign(context: context, design: design)
            applyAyuRuntimeSettings(context: context, flags: AyuSettingsStore.shared.featureFlags(), design: design)
            updateRefresh()
        },
        cycleFontProfile: {
            let design = AyuSettingsStore.shared.updateDesignSettings { current in
                current.fontProfile = ayuNextFontProfile(current.fontProfile)
            }
            ayuApplyDesign(context: context, design: design)
            applyAyuRuntimeSettings(context: context, flags: AyuSettingsStore.shared.featureFlags(), design: design)
            updateRefresh()
        },
        cycleAnimationLevel: {
            let design = AyuSettingsStore.shared.updateDesignSettings { current in
                current.animationLevel = ayuNextAnimationLevel(current.animationLevel)
            }
            ayuApplyDesign(context: context, design: design)
            applyAyuRuntimeSettings(context: context, flags: AyuSettingsStore.shared.featureFlags(), design: design)
            updateRefresh()
        },
        cycleBubbleStyle: {
            let design = AyuSettingsStore.shared.updateDesignSettings { current in
                current.bubbleStyle = ayuNextStyle(current.bubbleStyle, values: ["rounded", "compact", "square"])
            }
            ayuApplyDesign(context: context, design: design)
            applyAyuRuntimeSettings(context: context, flags: AyuSettingsStore.shared.featureFlags(), design: design)
            updateRefresh()
        },
        cycleBackgroundStyle: {
            _ = AyuSettingsStore.shared.updateDesignSettings { current in
                current.chatBackgroundStyle = ayuNextStyle(current.chatBackgroundStyle, values: ["gradient", "solid", "default"])
            }
            applyAyuRuntimeSettings(context: context, flags: AyuSettingsStore.shared.featureFlags(), design: AyuSettingsStore.shared.designSettings())
            updateRefresh()
        },
        applyDesignNow: {
            let design = AyuSettingsStore.shared.designSettings()
            ayuApplyDesign(context: context, design: design)
            applyAyuRuntimeSettings(context: context, flags: AyuSettingsStore.shared.featureFlags(), design: design)
            updateRefresh()
        },
        clearHistory: {
            AyuHistoryStore.shared.clearAll()
            updateRefresh()
        },
        resetAll: {
            AyuSettingsStore.shared.saveFeatureFlags(.default)
            AyuSettingsStore.shared.saveDesignSettings(.default)
            ayuApplyDesign(context: context, design: .default)
            applyAyuRuntimeSettings(context: context, flags: .default, design: .default)
            updateRefresh()
        }
    )

    let state = combineLatest(context.sharedContext.presentationData, refreshToken.get())
    |> map { presentationData, _ -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let flags = AyuSettingsStore.shared.featureFlags()
        let design = AyuSettingsStore.shared.designSettings()
        let historyCount = AyuHistoryStore.shared.recordsCount()

        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Ayu Settings"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back)
        )
        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: ayuSettingsEntries(presentationData: presentationData, flags: flags, design: design, historyCount: historyCount),
            style: .blocks,
            animateChanges: true
        )
        return (controllerState, (listState, arguments))
    }

    return ItemListController(context: context, state: state)
}
