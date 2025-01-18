import Foundation
import MagicKit
import SwiftUI

public struct EditorView: View, SuperEvent {
    public static let defaultDelegate = DefaultDelegate()

    internal let server: HTTPServer
    @State var isServerStarted = false
    @State var view: MagicWebView?
    @State var logViewVisible: Bool
    @State var topBarVisible: Bool = true

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

    public func hideLogView() {
        self.logViewVisible = false
    }

    public var body: some View {
        VStack {
            if topBarVisible {
                self.makeToolbar()
            }

            Group {
                if isServerStarted, let webView = view {
                    webView
                } else {
                    MagicLoading()
                        .magicTitle("Starting server...")
                }
            }

            if logViewVisible {
                self.getLogView()
            }
        }
        .onNotification(.httpServerStarted, perform: { _ in
            isServerStarted = true
            self.view = self.server.baseURL
                .makeWebView(onCustomMessage: onCustomMessage)
                .showLogView(false)
                .verboseMode(true)
        })
    }
}

#Preview {
    let v = EditorView()
    
    return VStack {
        v
    }.onAppear {
        v.hideLogView()
    }
}
