import Foundation
import MagicKit
import OSLog

public protocol EditorDelegate {
    func getHtml(_ uuid: String) async throws -> String?
    func onReady() -> Void
    func onUpdateNodes(_ nodes: [EditorNode]) -> Void
    func onLoading(_ reason: String) -> Void
    func chat(_ text: String, callback: @escaping (String) async throws -> Void) async throws
}

extension EditorDelegate {
    public func getHtml(_ uuid: String) async throws -> String? {
        return "Hi from DefaultDelegate"
    }

    public func onReady() {
        os_log("Editor Ready")
    }
    
    public func onUpdateNodes(_ nodes: [EditorNode]) {
        os_log("Editor Nodes Updated, Count: \(nodes.count)")
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
