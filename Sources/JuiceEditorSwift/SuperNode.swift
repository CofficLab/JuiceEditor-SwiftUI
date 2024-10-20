import CloudKit
import Foundation
import OSLog
import SwiftUI
import MagicKit

public protocol SuperNode: Hashable, Equatable, SuperLog, SuperThread {
    // MARK: Atrributes

    var uuid: String { get }
    var title: String { get }
    var text: String? { get }
    var content: String { get }
    var isBook: Bool { get }
    var createdAt: Date { get }
    var updatedAt: Date { get }
    var priority: Int { get }
    var parentId: String { get }
    var alwaysFolder: Bool { get }
    var type: SuperNodeType { get }
    var root: any SuperNode { get }
}

// MARK: Title

extension SuperNode {
    public var titleWithEmoji: String { emoji + " " + title }
    public var titleWithEmojiIfDebug: String {
        #if DEBUG
            titleWithEmoji
        #else
            t
        #endif
    }
}

// MARK: FileManager

extension SuperNode {
    var fileManager: FileManager {
        FileManager.default
    }
}

// MARK: 计算属性

extension SuperNode {
    /// equal to: uuid + type
    public var idWithType: String {
        self.uuid + self.type.rawValue
    }

    public var isPrivateRoot: Bool {
        false
    }

    public var isPublicRoot: Bool {
        false
    }

    public var isNotPrivateRoot: Bool {
        !isPrivateRoot
    }

    public var isNotChildOfPrivateRoot: Bool {
        false
    }

    public var isRoot: Bool {
        isPrivateRoot || isPublicRoot || isWebRoot
    }

    public var isNotRoot: Bool {
        !isRoot
    }

    public var createdAtString: String {
        createdAt.string
    }

    public var updatedAtString: String {
        updatedAt.string
    }

    public var isCloud: Bool {
        self is CKRecord
    }

    public var isLocal: Bool {
        false
    }

    public var isNotLocal: Bool {
        !isLocal
    }

    public var isWeb: Bool {
        false
    }

    public var isWebRoot: Bool {
        false
    }

    public var isNotWebRoot: Bool {
        !isWebRoot
    }

    public var isNotBook: Bool {
        !isBook
    }

    public var emoji: String {
        ""
    }
}

// MARK: Query

extension SuperNode {
    func isNode(_ uuid: String) -> Bool {
        self.uuid == uuid
    }
}

// MARK: Transform

extension SuperNode {
    func toJSONString() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys

        do {
            let jsonData = try encoder.encode([
                "title": self.title,
                "content": self.content,
                "uuid": self.uuid,
            ])
            let jsonString = String(data: jsonData, encoding: .utf8)!

            return jsonString
        } catch {
            os_log(.error, "\(error.localizedDescription)")
        }

        return ""
    }
}
