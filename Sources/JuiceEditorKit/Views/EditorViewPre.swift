import SwiftUI

struct EditorViewPre: View {
    var body: some View {
        TabView {
            // Basic usage
            EditorView()
                .tabItem {
                    Label("Default", systemImage: "doc.text")
                }
            
            // Without logs
            EditorView()
                .showLogView(false)
                .tabItem {
                    Label("No Logs", systemImage: "doc.text.fill")
                }
            
            // Quiet mode (no logs, no verbose)
            EditorView()
                .verbose(false)
                .showLogView(false)
                .tabItem {
                    Label("Quiet", systemImage: "speaker.slash")
                }
            
            // Custom delegate example
            EditorView(delegate: CustomDelegateExample())
                .tabItem {
                    Label("Custom", systemImage: "gear")
                }
        }
        .frame(width: 600, height: 600)
    }
}

// Example custom delegate implementation
private class CustomDelegateExample: EditorDelegate {
    func onReady() {
        print("Custom delegate: Editor is ready!")
    }
    
    func onUpdateNodes(_ nodes: [EditorNode]) {
        print("Custom delegate: Received \(nodes.count) nodes")
    }
    
    func onLoading(_ reason: String) {
        print("Custom delegate: Loading - \(reason)")
    }
}

#Preview {
    EditorViewPre()
} 
