import SwiftUI
import MagicKit

// MARK: - Preview Delegate

class PreviewDelegate: EditorDelegate {
    func getHtml(_ uuid: String) async throws -> String? {
        return """
        # Welcome to Editor Preview
        
        This is a preview of the editor with different configurations.
        
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
}

// MARK: - Editor Preview

struct EditorPreview: View {
    var body: some View {
        TabView {
            DefaultPreview()
                .tabItem {
                    Label("Default", systemImage: "doc.text")
                }
            
            MinimalPreview()
                .tabItem {
                    Label("Minimal", systemImage: "doc.text.fill")
                }
            
            DebugPreview()
                .tabItem {
                    Label("Debug", systemImage: "terminal")
                }
            
            CustomPreview()
                .tabItem {
                    Label("Custom", systemImage: "slider.horizontal.3")
                }
        }
        .frame(minWidth: 600, minHeight: 750)
    }
}

// MARK: - Default Preview

struct DefaultPreview: View {
    @StateObject private var editor = Editor(delegate: PreviewDelegate())
    
    var body: some View {
        editor.view()
    }
}

// MARK: - Minimal Preview

struct MinimalPreview: View {
    @StateObject private var editor = Editor(delegate: PreviewDelegate())
    
    var body: some View {
        editor.view(
            showTopBar: false,
            showLogView: false
        )
    }
}

// MARK: - Debug Preview

struct DebugPreview: View {
    @StateObject private var editor = Editor(delegate: PreviewDelegate(), verbose: true)
    
    var body: some View {
        VStack {
            editor.view(
                showTopBar: true,
                showLogView: true
            )
            
            Text("Debug Mode: Verbose logging enabled")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
        }
    }
}

// MARK: - Custom Preview

struct CustomPreview: View {
    @StateObject private var editor = Editor(delegate: PreviewDelegate())
    @State private var content = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // 自定义工具栏
            customToolbar
            
            // 编辑器视图
            editor.view(
                showTopBar: false,
                showLogView: false
            )
        }
    }
    
    private var customToolbar: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Custom Toolbar")
                    .font(.headline)
                
                Spacer()
                
                TextField("Content", text: $content)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                
                Button("Save") {
                    Task {
                        try? await editor.setContent(content)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            Divider()
        }
        .background(Color(.windowBackgroundColor))
    }
}

// MARK: - Previews

#Preview("All Features") {
    EditorPreview()
}
