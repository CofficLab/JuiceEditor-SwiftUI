import JuiceEditorSwift
import OSLog
import SwiftUI
import MagicKit

@main
struct JuiceEditorTestApp: App, SuperLog {
    let emoji = "🍎"
    
    @State var editorView: EditorView?

    var body: some Scene {
        WindowGroup {
            if let e = editorView {
                e
            } else {
                ProgressView().onAppear {
                    self.editorView = EditorView(delegate: self)
                }
            }
        }
    }
}

extension JuiceEditorTestApp: EditorDelegate {
    func getHtml(_ uuid: String) -> String? {
        "<h1>Hi from JuiceEditorTestApp</h1><p>hi</p><p>你好</p>"
    }

    func onReady() {
        Task {
            try? await self.editorView?.setHtmlByRequest("1")
        }
    }
    
    func onUpdateDoc(_ html: String) {
        os_log("\(t)OnUpdateDoc: \(html)")
    }
}
