import SwiftUI
import JuiceEditorSwift

@main
struct JuiceEditorTestApp: App {
    var body: some Scene {
        WindowGroup {
            EditorView()
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.makeKeyAndOrderFront(nil)
                    }
                }
        }
    }
}
