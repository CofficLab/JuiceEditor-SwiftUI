import Foundation
import MagicKit
import OSLog

public protocol EditorDelegate {
    func getHtml(_ uuid: String) -> String?
    func onReady() -> Void
    func translate(_ text: String, language: String) async -> String
    func onUpdateDoc(_ data: [String: Any]) -> Void
    func onLoading(_ reason: String) -> Void
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

    public func onUpdateDoc(_ data: [String: Any]) -> Void {
        os_log("Editor Doc Updated")
    }

    public func onConfigChanged() -> Void {
        os_log("Editor Config Changed")
    }

    public func onLoading(_ reason: String) -> Void {
        os_log("Editor Loading -> \(reason)")
    }
}

public struct DefaultDelegate: EditorDelegate {}
