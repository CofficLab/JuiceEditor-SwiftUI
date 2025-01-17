import Foundation
import MagicKit
import SwiftUI

public struct EditorView: SwiftUI.View, SuperEvent {
    public static let defaultDelegate = DefaultDelegate()

    private let nc = NotificationCenter.default

    @State var server: HTTPServer
    @State var isServerStarted = false
    @State var webView: MagicWebView?
    
    public let delegate: EditorDelegate
    
    public var isEditable: Bool
    public var showToolbar: Bool
    public var showEditor: Bool
    public var isVerbose: Bool
    public var logViewVisible: Bool
    
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
            EditorControlPanel(
                isEditable: .constant(isEditable),
                showToolbar: .constant(showToolbar),
                showEditor: .constant(showEditor),
                logViewVisible: .constant(logViewVisible),
                isVerbose: .constant(isVerbose)
            )
            
            Group {
                VStack {
                    if isServerStarted, let webView = webView {
                        webView
                    } else {
                        MagicLoading().magicTitle("Starting server...")
                            .onAppear {
                                server.startServer(verbose: isVerbose)
                            }
                    }
                    
                    if logViewVisible {
                        Logger.logView()
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

extension EditorDelegate {
    public func getHtml(_ uuid: String) async throws -> String? {
        return "Hi from DefaultDelegate"
    }

    public func onReady() {
        warning("EditorDelegate: Editor Ready")
    }

    public func onUpdateNodes(_ nodes: [EditorNode]) {
        warning("Editor Nodes Updated, Count: \(nodes.count)")
    }

    public func onConfigChanged() {
        warning("Editor Config Changed")
    }

    public func onLoading(_ reason: String) {
        warning("Editor Loading -> \(reason)")
    }

    public func chat(_ text: String, callback: @escaping (String) async throws -> Void) async throws {
        let characters = ["You said: "] + Array(text)
        for char in characters {
            try await callback("\(char)")
            try await Task.sleep(nanoseconds: 500000000)
        }

        try await callback("[DONE]\n")
    }
}

public struct DefaultDelegate: EditorDelegate {}

#Preview {
    EditorViewPre()
} 
