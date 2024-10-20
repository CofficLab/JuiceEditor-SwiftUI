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
    var titleWithEmoji: String { emoji + " " + title }
    var titleWithEmojiIfDebug: String {
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
    var idWithType: String {
        self.uuid + self.type.rawValue
    }

    var isPrivateRoot: Bool {
        false
    }

    var isPublicRoot: Bool {
        false
    }

    var isNotPrivateRoot: Bool {
        !isPrivateRoot
    }

    var isNotChildOfPrivateRoot: Bool {
        false
    }

    var isRoot: Bool {
        isPrivateRoot || isPublicRoot || isWebRoot
    }

    var isNotRoot: Bool {
        !isRoot
    }

    var createdAtString: String {
        createdAt.string
    }

    var updatedAtString: String {
        updatedAt.string
    }

    var isCloud: Bool {
        self is CKRecord
    }

    var isLocal: Bool {
        false
    }

    var isNotLocal: Bool {
        !isLocal
    }

    var isWeb: Bool {
        false
    }

    var isWebRoot: Bool {
        false
    }

    var isNotWebRoot: Bool {
        !isWebRoot
    }

    var isNotBook: Bool {
        !isBook
    }

    var emoji: String {
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
