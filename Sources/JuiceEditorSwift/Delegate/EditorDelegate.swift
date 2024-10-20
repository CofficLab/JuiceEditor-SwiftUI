import Foundation
import MagicKit
import OSLog

public protocol EditorDelegate {
    func getHtml(_ uuid: String) -> String?
    func onReady() -> Void
    func translate(_ text: String, language: String) async -> String
}

extension EditorDelegate {
    public func getHtml(_ uuid: String) -> String? {
        return "Hi from DefaultDelegate"
    }

    public func onReady() {
        os_log("Editor Ready")
    }

    public func translate(_ text: String, language: String) async -> String {
        return text + "(translated by default delegate)"
    }
}

public struct DefaultDelegate: EditorDelegate {
    let emoji = "👮"
}
