import JuiceEditorSwift
import OSLog
import SwiftUI

@main
struct JuiceEditorTestApp: App {
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
        "Hi from JuiceEditorTestApp"
    }

    func onReady() { Task {
        try? await self.editorView?.setHtmlByRequest("1")
    }
    }
}
