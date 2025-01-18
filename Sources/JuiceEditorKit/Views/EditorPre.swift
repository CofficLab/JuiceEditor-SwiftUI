import SwiftUI

struct EditorPreview: View {
    var body: some View {
        TabView {
            // Default configuration
            EditorView()
                .tabItem {
                    Label("Default", systemImage: "doc.text")
                }
            
            // Minimal configuration (no toolbar, no logs)
            EditorView()
                .withToolbarVisible(false)
                .withLogViewVisible(false)
                .tabItem {
                    Label("Minimal", systemImage: "doc.text.fill")
                }
            
            // Verbose mode
            EditorView()
                .withVerbose(true)
                .tabItem {
                    Label("Verbose", systemImage: "terminal")
                }
            
            // Logs only
            EditorView()
                .withToolbarVisible(false)
                .withLogViewVisible(true)
                .tabItem {
                    Label("Logs", systemImage: "text.alignleft")
                }
        }
        .frame(minHeight: 800)
        .frame(minWidth: 500)
    }
}

#Preview {
    EditorPreview()
}

