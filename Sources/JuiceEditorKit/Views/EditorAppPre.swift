import Foundation
import SwiftUI

struct EditorAppPre: View {
    let editorKit = EditorApp()
    
    var body: some View {
        VStack {
            editorKit.makeToolbar()
            
            editorKit.getEditorView()
            
            editorKit.getLogView()
        }
        .frame(minHeight: 800)
    }
}

#Preview {
    EditorAppPre()
        .frame(height: 800)
}
