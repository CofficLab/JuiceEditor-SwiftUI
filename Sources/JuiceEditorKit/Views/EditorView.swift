import Foundation
import MagicKit
import SwiftUI

public struct EditorView: SwiftUI.View, SuperEvent {
    public static let defaultDelegate = DefaultDelegate()

    @State var server: HTTPServer
    @State var isServerStarted = false
    @State var webView: MagicWebView?
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
        self.server = HTTPServer(directoryPath: Config.webAppPath, delegate: delegate, verbose: verbose)
        self.isVerbose = verbose
        self.logViewVisible = showLogView
        self.isEditable = true
        self.showToolbar = true
        self.showEditor = true
    }

    public var body: some View {
        VStack(spacing: 0) {
            Group {
                if isServerStarted, let webView = webView {
                    webView
                } else {
                    MagicLoading().magicTitle("Starting server...")
                        .onAppear {
                            server.startServer(verbose: isVerbose)
                        }
                }
            }
            .onNotification(.httpServerStarted, onServerStarted)
        }
    }
}

public protocol EditorDelegate {
    func getHtml(_ uuid: String) async throws -> String?
    func onReady() -> Void
    func onUpdateNodes(_ nodes: [EditorNode]) -> Void
    func onLoading(_ reason: String) -> Void
    func chat(_ text: String, callback: @escaping (String) async throws -> Void) async throws
}

#Preview {
    EditorPre()
}
