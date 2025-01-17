import SwiftUI

public extension EditorView {
    func verbose(_ isVerbose: Bool) -> EditorView {
        var view = self
        view.verbose = isVerbose
        return view
    }
    
    func showLogView(_ show: Bool) -> EditorView {
        var view = self
        view.showLogView = show
        return view
    }
}

#Preview {
    EditorView()
        .verbose(true)
        .showLogView(true)
        .frame(height: 1000)
        .frame(width: 700)
}
