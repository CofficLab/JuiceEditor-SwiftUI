import Foundation
import MagicKit
import SwiftUI

public struct EditorView: SwiftUI.View, SuperLog {
    public static let defaultDelegate = DefaultDelegate()

    @State private var server: HTTPServer
    @State private var isServerStarted = false
    @State public var webView: MagicWebView
    
    public let delegate: EditorDelegate
    public let verbose: Bool
    public let logger: MagicLogger

    public init(delegate: EditorDelegate = EditorView.defaultDelegate, verbose: Bool) {
        let logger = MagicLogger.shared
        self.logger = logger
        self.delegate = delegate
        self.server = HTTPServer(directoryPath: Config.webAppPath, delegate: delegate, verbose: verbose)
        self.verbose = verbose
        self.webView = JSConfig.makeView(url: "about:blank", verbose: verbose, logger: logger)
    }

    public var body: some View {
        ZStack {
            if isServerStarted {
                webView
            } else {
                Text("Starting server...")
                    .onAppear() {
                        server.startServer(verbose: verbose)
                    }
            }
        }
        .frame(minHeight: 600)
        .onReceive(NotificationCenter.default.publisher(for: .httpServerStarted), perform: onServerStarted)
        .onReceive(NotificationCenter.default.publisher(for: .jsReady), perform: onJSReady)
        .onReceive(NotificationCenter.default.publisher(for: .jsCallUpdateArticle), perform: onJSCallUpdateArticle)
        .onReceive(NotificationCenter.default.publisher(for: .jsCallUpdateNodes), perform: onJSCallUpdateNodes)
        .onReceive(NotificationCenter.default.publisher(for: .jsCallConfigChanged), perform: onConfigChanged)
        .onReceive(NotificationCenter.default.publisher(for: .jsLoading), perform: onLoading)
    }
}

// MARK: Action

extension EditorView {
    public func setContent(_ uuid: String) async throws {
        try await self.setContentFromWeb(
            self.server.baseURL.absoluteString + "/api/node/" + uuid + "/html",
            uuid: uuid,
            verbose: self.verbose
        )
    }
}

// MARK: Event Handler

extension EditorView {
    func onJSReady(_ n: Notification) {
        Task {
            if verbose {
                logger.info("\(self.t)Editor Page Ready")
            }

            do {
                try await self.setChatApi(server.chatApi)
                try await self.setDrawLink(server.drawIoLink)

                self.delegate.onReady()
            } catch {
                logger.error("\(error)")
            }
        }
    }

    func onServerStarted(_ n: Notification) {
        isServerStarted = true
        self.webView = webView.goto("http://localhost:5173/".toURL())
    }

    func onJSCallUpdateArticle(_ n: Notification) {
        let data = n.userInfo as? [String: Any]

        guard let data = data else {
            logger.warning("\(self.t)No Data")
            return
        }
        
        guard let nodeData = data["node"] as? [String: Any] else {
            return
        }

        Task {
            do {
                let node = try await EditorNode.getEditorNodeFromData(nodeData, reason: "EditorView.onJSCallUpdateArticle", verbose: verbose)
                delegate.onUpdateNodes([node])
            } catch {
                logger.error("\(error)")
            }
        }
    }

    func onJSCallUpdateNodes(_ n: Notification) {
        let data = n.userInfo as? [String: Any]

        guard let data = data else {
            logger.warning("\(self.t)No Data")
            return
        }

        Task {
            do {
                let nodes = try await EditorNode.getEditorNodesFromData(data, reason: "EditorView.onJSCallUpdateNodes", verbose: verbose)
                delegate.onUpdateNodes(nodes)
            } catch {
                logger.error("\(error)")
            }
        }
    }

    func onConfigChanged(_ n: Notification) {
        delegate.onConfigChanged()
    }

    func onLoading(_ n: Notification) {
        let data = n.userInfo as? [String: Any]

        guard let data = data else {
            return
        }

        delegate.onLoading(data["reason"] as! String)
    }
}

#Preview {
    EditorView(verbose: true)
        .frame(height: 1000)
        .frame(width: 700)
}
