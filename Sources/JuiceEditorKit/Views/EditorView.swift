import Foundation
import MagicKit
import os
import SwiftUI

public struct EditorView: SwiftUI.View, SuperLog {
    let emoji = Config.rootEmoji + " 🖥️"
    let logger = Config.makeLogger("EditorView")

    public static let defaultDelegate = DefaultDelegate()

    @State private var server: HTTPServer
    @State private var isServerStarted = false

    public let webView: WebView
    public let delegate: EditorDelegate
    public let verbose: Bool

    public init(delegate: EditorDelegate = EditorView.defaultDelegate, verbose: Bool) {
        if verbose {
            os_log("\(Logger.initLog) EditorView")
        }
        
        self.delegate = delegate
        self.server = HTTPServer(directoryPath: Config.webAppPath, delegate: delegate, verbose: verbose)
        self.verbose = verbose
        self.webView = JSConfig.makeView(url: "about:blank", verbose: verbose)
    }

    public var body: some View {
        Group {
            if isServerStarted {
                webView
                    .onAppear {
                        webView.goto(server.baseURL)
                    }
            } else {
                Text("Starting server...")
                    .onAppear() {
                        server.startServer(verbose: verbose)
                    }
            }
        }
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
            verbose: self.verbose
        )
    }
}

// MARK: Event Handler

extension EditorView {
    func onJSReady(_ n: Notification) {
        Task {
            if verbose {
                os_log("\(self.t)Editor Page Ready")
            }

            do {
                try await self.setChatApi(server.chatApi)
                try await self.setDrawLink(server.drawIoLink)

                self.delegate.onReady()
            } catch {
                os_log(.error, "\(self.t)\(error.localizedDescription)")
                os_log(.error, "\(error)")
            }
        }
    }

    func onServerStarted(_ n: Notification) {
        isServerStarted = true
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
                os_log(.error, "\(self.t)\(error)")
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
                os_log(.error, "\(self.t)\(error)")
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
}
