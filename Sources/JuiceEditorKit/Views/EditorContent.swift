import MagicKit
import SwiftUI

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
            if let errorMessage = editor.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.white)
                    Text(errorMessage)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        editor.setErrorMessageNil()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .background(Color.red.opacity(0.8))
            }

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
                MagicLogger.logView()
            }
        }
    }
}

#Preview {
    EditorPreview()
}
