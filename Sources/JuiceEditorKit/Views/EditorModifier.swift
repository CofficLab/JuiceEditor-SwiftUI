import SwiftUI

public extension EditorView {
    func withVerbose(_ value: Bool) -> EditorView {
        var view = self
        view.isVerbose = value
        return view
    }
    
    func withLogViewVisible(_ value: Bool) -> EditorView {
        var view = self
        view.logViewVisible = value
        return view
    }
    
    func withToolbarVisible(_ value: Bool) -> EditorView {
        var view = self
        view.showToolbar = value
        return view
    }
}

#Preview {
    EditorPreview()
}
