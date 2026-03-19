import Foundation

public struct AyuFeatureFlags: Codable, Equatable {
    public var ghostModeEnabled: Bool
    public var manualReadAckEnabled: Bool
    public var antiRecallEnabled: Bool
    public var historyEnabled: Bool
    public var streamerModeEnabled: Bool
    public var messageFiltersEnabled: Bool
    public var customMarksEnabled: Bool

    public init(
        ghostModeEnabled: Bool,
        manualReadAckEnabled: Bool,
        antiRecallEnabled: Bool,
        historyEnabled: Bool,
        streamerModeEnabled: Bool,
        messageFiltersEnabled: Bool,
        customMarksEnabled: Bool
    ) {
        self.ghostModeEnabled = ghostModeEnabled
        self.manualReadAckEnabled = manualReadAckEnabled
        self.antiRecallEnabled = antiRecallEnabled
        self.historyEnabled = historyEnabled
        self.streamerModeEnabled = streamerModeEnabled
        self.messageFiltersEnabled = messageFiltersEnabled
        self.customMarksEnabled = customMarksEnabled
    }

    public static let `default` = AyuFeatureFlags(
        ghostModeEnabled: false,
        manualReadAckEnabled: false,
        antiRecallEnabled: false,
        historyEnabled: false,
        streamerModeEnabled: false,
        messageFiltersEnabled: false,
        customMarksEnabled: false
    )

    private enum CodingKeys: String, CodingKey {
        case ghostModeEnabled = "ghost_mode_enabled"
        case manualReadAckEnabled = "manual_read_ack_enabled"
        case antiRecallEnabled = "anti_recall_enabled"
        case historyEnabled = "history_enabled"
        case streamerModeEnabled = "streamer_mode_enabled"
        case messageFiltersEnabled = "message_filters_enabled"
        case customMarksEnabled = "custom_marks_enabled"
    }
}

public enum AyuDesignPreset: String, Codable, CaseIterable {
    case ayuOcean = "ayu_ocean"
    case ayuDark = "ayu_dark"
    case ayuClassic = "ayu_classic"
}

public enum AyuFontProfile: String, Codable, CaseIterable {
    case system
    case compact
    case readable
}

public enum AyuAnimationLevel: String, Codable, CaseIterable {
    case off
    case standard
    case enhanced
}

public struct AyuDesignSettings: Codable, Equatable {
    public var preset: AyuDesignPreset
    public var accentColor: UInt32?
    public var chatBackgroundStyle: String
    public var bubbleStyle: String
    public var fontProfile: AyuFontProfile
    public var animationLevel: AyuAnimationLevel
    public var defaultOnFirstLaunch: Bool

    public init(
        preset: AyuDesignPreset,
        accentColor: UInt32?,
        chatBackgroundStyle: String,
        bubbleStyle: String,
        fontProfile: AyuFontProfile,
        animationLevel: AyuAnimationLevel,
        defaultOnFirstLaunch: Bool
    ) {
        self.preset = preset
        self.accentColor = accentColor
        self.chatBackgroundStyle = chatBackgroundStyle
        self.bubbleStyle = bubbleStyle
        self.fontProfile = fontProfile
        self.animationLevel = animationLevel
        self.defaultOnFirstLaunch = defaultOnFirstLaunch
    }

    public static let `default` = AyuDesignSettings(
        preset: .ayuOcean,
        accentColor: nil,
        chatBackgroundStyle: "gradient",
        bubbleStyle: "rounded",
        fontProfile: .system,
        animationLevel: .standard,
        defaultOnFirstLaunch: true
    )

    private enum CodingKeys: String, CodingKey {
        case preset
        case accentColor = "accent_color"
        case chatBackgroundStyle = "chat_background_style"
        case bubbleStyle = "bubble_style"
        case fontProfile = "font_profile"
        case animationLevel = "animation_level"
        case defaultOnFirstLaunch = "default_on_first_launch"
    }
}

public struct AyuHistoryRecord: Codable, Equatable {
    public var chatId: Int64
    public var messageId: Int64
    public var authorId: Int64?
    public var timestamp: Int64
    public var textSnapshot: String?
    public var mediaRef: String?
    public var deletedAt: Int64?
    public var editVersions: [String]

    public init(
        chatId: Int64,
        messageId: Int64,
        authorId: Int64?,
        timestamp: Int64,
        textSnapshot: String?,
        mediaRef: String?,
        deletedAt: Int64?,
        editVersions: [String]
    ) {
        self.chatId = chatId
        self.messageId = messageId
        self.authorId = authorId
        self.timestamp = timestamp
        self.textSnapshot = textSnapshot
        self.mediaRef = mediaRef
        self.deletedAt = deletedAt
        self.editVersions = editVersions
    }

    private enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case messageId = "message_id"
        case authorId = "author_id"
        case timestamp
        case textSnapshot = "text_snapshot"
        case mediaRef = "media_ref"
        case deletedAt = "deleted_at"
        case editVersions = "edit_versions"
    }
}
