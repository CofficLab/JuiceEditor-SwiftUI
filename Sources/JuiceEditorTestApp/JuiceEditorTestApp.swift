import SwiftUI
import JuiceEditorSwift

@main
struct JuiceEditorTestApp: App {
    var body: some Scene {
        WindowGroup {
            DebugView()
                .onAppear {
                    if let window = NSApplication.shared.windows.first {
                        window.makeKeyAndOrderFront(nil)
                    }
                }
        }
    }
}
