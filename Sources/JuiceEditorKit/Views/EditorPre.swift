import Foundation
import SwiftUI

struct EditorPre: View {
    let editorKit = EditorView()
    
    var body: some View {
        VStack {
            editorKit.makeToolbar()
            
            editorKit
            
            editorKit.getLogView()
        }
        .frame(minHeight: 800)
    }
}

#Preview {
    EditorPre()
        .frame(height: 800)
}
