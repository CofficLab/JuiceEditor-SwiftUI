import Foundation
import SwiftUI

struct EditorDemo: View {
    let editor = EditorView()
    
    var body: some View {
        VStack {
            editor.makeToolbar()
            
            editor
            
            editor.getLogView()
        }
        .frame(minHeight: 800)
    }
}

#Preview {
    EditorDemo()
        .frame(height: 800)
}
