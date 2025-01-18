import Foundation
import MagicKit
import SwiftUI

public struct EditorView: SwiftUI.View, SuperEvent {
    public static let defaultDelegate = DefaultDelegate()

    @State var server: HTTPServer
    @State var isServerStarted = false
    @State var view: MagicWebView?
    @State public var logViewVisible: Bool

    public let delegate: EditorDelegate
    public var isEditable: Bool
    public var showToolbar: Bool
    public var showEditor: Bool
    public var isVerbose: Bool

    public init(
        delegate: EditorDelegate = EditorView.defaultDelegate,
        verbose: Bool = true,
        showLogView: Bool = true
    ) {
        self.delegate = delegate
        self.server = HTTPServer(delegate: delegate)
        self.isVerbose = verbose
        self.logViewVisible = showLogView
        self.isEditable = true
        self.showToolbar = true
        self.showEditor = true
        
        self.server.startServer(verbose: true)
    }

    public var body: some View {
        VStack(spacing: 0) {
            Group {
                if isServerStarted, let webView = view {
                    webView
                } else {
                    MagicLoading()
                        .magicTitle("Starting server...")
                }
            }
            .onNotification(.httpServerStarted, onServerStarted)
        }
    }
}

#Preview {
    EditorDemo()
}
