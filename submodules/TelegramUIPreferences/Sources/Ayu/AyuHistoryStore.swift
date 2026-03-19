import Foundation

public final class AyuHistoryStore {
    public static let shared = AyuHistoryStore()

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let lock = NSLock()
    private let fileURL: URL

    public init(baseDirectory: URL? = nil) {
        let resolvedBase: URL
        if let baseDirectory {
            resolvedBase = baseDirectory
        } else {
            let defaultBase = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            resolvedBase = defaultBase ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        }
        self.fileURL = resolvedBase.appendingPathComponent("ayugram-history-v1.json", isDirectory: false)
    }

    public func allRecords() -> [AyuHistoryRecord] {
        self.lock.lock()
        defer { self.lock.unlock() }
        return self.loadRecordsLocked()
    }

    public func recordsCount() -> Int {
        return self.allRecords().count
    }

    public func upsert(_ record: AyuHistoryRecord) {
        self.lock.lock()
        defer { self.lock.unlock() }

        var records = self.loadRecordsLocked()
        if let index = records.firstIndex(where: { $0.chatId == record.chatId && $0.messageId == record.messageId }) {
            records[index] = record
        } else {
            records.append(record)
        }
        self.saveRecordsLocked(records)
    }

    public func markDeleted(chatId: Int64, messageId: Int64, deletedAt: Int64 = Int64(Date().timeIntervalSince1970)) {
        self.lock.lock()
        defer { self.lock.unlock() }

        var records = self.loadRecordsLocked()
        if let index = records.firstIndex(where: { $0.chatId == chatId && $0.messageId == messageId }) {
            records[index].deletedAt = deletedAt
        } else {
            records.append(
                AyuHistoryRecord(
                    chatId: chatId,
                    messageId: messageId,
                    authorId: nil,
                    timestamp: deletedAt,
                    textSnapshot: nil,
                    mediaRef: nil,
                    deletedAt: deletedAt,
                    editVersions: []
                )
            )
        }
        self.saveRecordsLocked(records)
    }

    public func clearAll() {
        self.lock.lock()
        defer { self.lock.unlock() }
        self.saveRecordsLocked([])
    }

    private func ensureParentDirectoryLocked() {
        let parent = self.fileURL.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: parent, withIntermediateDirectories: true, attributes: nil)
    }

    private func loadRecordsLocked() -> [AyuHistoryRecord] {
        guard let data = try? Data(contentsOf: self.fileURL) else {
            return []
        }
        return (try? self.decoder.decode([AyuHistoryRecord].self, from: data)) ?? []
    }

    private func saveRecordsLocked(_ records: [AyuHistoryRecord]) {
        self.ensureParentDirectoryLocked()
        guard let data = try? self.encoder.encode(records) else {
            return
        }
        try? data.write(to: self.fileURL, options: .atomic)
    }
}
