import SwiftUI
import JuiceEditorKit

@main
struct JuiceEditorTestApp: App {
    @StateObject private var editor: Editor
    
    init() {
        let delegate = TestDelegate()
        _editor = StateObject(wrappedValue: Editor(delegate: delegate))
    }
    
    var body: some Scene {
        WindowGroup {
            editor.view(showTopBar: true, showLogView: true)
        }
    }
}

// MARK: - Test Delegate

final class TestDelegate: EditorDelegate {
    func getHtml(_ uuid: String) async throws -> String? {
        return """
        # Welcome to JuiceEditor Test App
        
        This is a test application for JuiceEditor.
        
        ## Features
        
        - Rich text editing
        - Markdown support
        - Toolbar customization
        - And more...
        """
    }
    
    func onReady() {
        print("Editor is ready!")
    }
    
    func onUpdateNodes(_ nodes: [EditorNode]) {
        print("Nodes updated: \(nodes.count)")
    }
}

#Preview {
    let editor = Editor(delegate: TestDelegate())
    return editor.view()
}
