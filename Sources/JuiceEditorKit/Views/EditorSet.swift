import Foundation
import SwiftUI

public extension EditorView {
    func setContentFromWeb(_ uuid: String) async throws {
        try await self.setContentFromWeb(
            self.server.baseURL.absoluteString + "/api/node/" + uuid + "/html",
            uuid: uuid
        )
    }

    func setContent(_ content: String) async throws {
        try await self.run("window.editor.setContent(`\(content)`)")
    }

    func setToolbarVisible(_ v: Bool) async throws -> Any {
        await v ? try showToolbar() : try hideToolbar()
    }

    @discardableResult
    func setEditable(_ v: Bool) async throws -> Any {
        await v ? try enableEdit() : try disableEdit()
    }

    func setEditorVisible(_ v: Bool) async throws -> Any {
        await v ? try showEditor() : try hideEditor()
    }

    @discardableResult
    func setChatApi(_ s: String) async throws -> Any {
        info("setChatApi 🛜🛜🛜 -> \(s)")

        return try await run("window.editor.setChatApi(`\(s)`)")
    }

    @discardableResult
    func setDrawLink(_ link: String) async throws -> Any {
        try await run("window.editor.setDrawLink('\(link)')")
    }

    func setNodeBase64(_ nodeBase64: String) async throws -> Any {
        let verbose = false

        if verbose {
            info("setNodeBase64 -> \(nodeBase64.mini())")
        }

        return try await run("api.node.setNodeBase64(`\(nodeBase64)`)")
    }

    @discardableResult
    func setContentFromWeb(_ url: String, uuid: String) async throws -> Any {
        if verbose {
            info("setContentFromWeb 🛜🛜🛜 -> \(url) -> \(uuid)")
        }

        return try await run("window.editor.setContentFromUrl(`\(url)`, `\(uuid)`)")
    }

    func setParagraph() async throws -> Any {
        try await run("window.editor.setParagraph()")
    }

    func setHeading1() async throws -> Any {
        try await run("window.editor.setHeading1()")
    }

    func setHeading2() async throws -> Any {
        try await run("window.editor.setHeading2()")
    }

    func setHeading3() async throws -> Any {
        try await run("window.editor.setHeading3()")
    }

    func setHeading4() async throws -> Any {
        try await run("window.editor.setHeading4()")
    }

    func setHeading5() async throws -> Any {
        try await run("window.editor.setHeading5()")
    }

    func setHeading6() async throws -> Any {
        try await run("window.editor.setHeading6()")
    }
}

#Preview {
    EditorView()
        .frame(height: 800)
}
