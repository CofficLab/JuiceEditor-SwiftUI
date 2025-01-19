import SwiftUI
import MagicKit

public struct EditorContent: View {
    @ObservedObject var editor: Editor
    
    private var topBarVisible: Bool = true
    private var logViewVisible: Bool = false
    
    init(
        editor: Editor,
        showTopBar: Bool = true,
        showLogView: Bool = false
    ) {
        self.editor = editor
        self.topBarVisible = showTopBar
        self.logViewVisible = showLogView
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if topBarVisible {
                EditorToolbar(editor: editor)
            }

            Group {
                if editor.isServerStarted, let webView = editor.webView {
                    webView
                } else {
                    MagicLoading()
                        .magicTitle("Starting server...")
                }
            }

            if logViewVisible {
                getLogView()
            }
        }
    }
    
    @ViewBuilder
    private func getLogView() -> some View {
        ScrollView {
            Text("Editor Logs")
                .font(.caption)
        }
        .frame(height: 100)
    }
} 

#Preview {
    EditorPreview()
}
