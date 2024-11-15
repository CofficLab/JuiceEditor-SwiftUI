import Foundation
import MagicKit
import os
import SwiftUI

public struct EditorView: SwiftUI.View, SuperLog {
    let emoji = "📄"
    let logger = Config.makeLogger("EditorView")

    public static let defaultDelegate = DefaultDelegate()

    @State private var server: HTTPServer
    @State private var isServerStarted = false

    public let webView = JSConfig.makeView(url: "about:blank")
    public let delegate: EditorDelegate

    public init(delegate: EditorDelegate = EditorView.defaultDelegate) {
        self.delegate = delegate
        self.server = HTTPServer(directoryPath: Config.webAppPath, delegate: delegate)
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
                    .task {
                        server.startServer()
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .httpServerStarted), perform: onServerStarted)
        .onReceive(NotificationCenter.default.publisher(for: .jsReady), perform: onJSReady)
        .onReceive(NotificationCenter.default.publisher(for: .jsCallUpdateDoc), perform: onJSCallUpdateDoc)
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
            verbose: true
        )
    }
}

// MARK: Event Handler

extension EditorView {
    func onJSReady(_ n: Notification) {
        Task {
            let verbose = true

            if verbose {
                os_log("\(self.t)JSReady")
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

    func onJSCallUpdateDoc(_ n: Notification) {
        let data = n.userInfo as? [String: Any]

        guard let data = data else {
            logger.warning("\(self.t)No Data")
            return
        }

        delegate.onUpdateDoc(data)
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
    EditorView()
}
