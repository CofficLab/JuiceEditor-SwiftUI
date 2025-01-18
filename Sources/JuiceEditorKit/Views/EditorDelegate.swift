import Foundation
import SwiftUI

extension EditorDelegate {
    public func getHtml(_ uuid: String) async throws -> String? {
        return "Hi from DefaultDelegate"
    }

    public func onReady() {
        warning("EditorDelegate: Editor Ready")
    }

    public func onUpdateNodes(_ nodes: [EditorNode]) {
        warning("Editor Nodes Updated, Count: \(nodes.count)")
    }

    public func onConfigChanged() {
        warning("Editor Config Changed")
    }

    public func onLoading(_ reason: String) {
        warning("Editor Loading -> \(reason)")
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

#Preview {
    EditorPre()
        .frame(height: 800)
}
