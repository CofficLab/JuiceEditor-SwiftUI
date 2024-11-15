import Foundation
import MagicKit
import OSLog

public protocol EditorDelegate {
    func getHtml(_ uuid: String) -> String?
    func onReady() -> Void
    func onUpdateDoc(_ data: [String: Any]) -> Void
    func onLoading(_ reason: String) -> Void
    func chat(_ text: String, callback: @escaping (String) async throws -> Void) async throws
}

extension EditorDelegate {
    public func getHtml(_ uuid: String) -> String? {
        return "Hi from DefaultDelegate"
    }

    public func onReady() {
        os_log("Editor Ready")
    }

    public func onUpdateDoc(_ data: [String: Any]) {
        os_log("Editor Doc Updated")
    }

    public func onConfigChanged() {
        os_log("Editor Config Changed")
    }

    public func onLoading(_ reason: String) {
        os_log("Editor Loading -> \(reason)")
    }

    public func chat(_ text: String, callback: @escaping (String) async throws -> Void) async throws {
        let characters = ["You said: "] + Array(text)
        for char in characters {
            try await callback("\(char)")
            try await Task.sleep(nanoseconds: 500000000)
        }

        try await callback("[DONE]\n")
    }
}

public struct DefaultDelegate: EditorDelegate {}
