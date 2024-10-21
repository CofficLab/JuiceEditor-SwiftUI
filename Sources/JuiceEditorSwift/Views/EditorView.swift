import Foundation
import os
import SwiftUI
import MagicKit

public struct EditorView: SwiftUI.View, SuperLog {
    let emoji = "📄"
    let logger = Config.makeLogger("EditorView")
    
    public static let defaultDelegate = DefaultDelegate()
    
    @State private var server: HTTPServer
    @State private var isServerStarted = false

    public let webView = JSConfig.makeView(url: "about:blank")
    public let delegate: EditorDelegate

    public init(delegate:  EditorDelegate = EditorView.defaultDelegate) {
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

// MARK: Event Handler

extension EditorView {
    func onJSReady(_ n: Notification) {
        Task {
            try await self.setBaseUrl(server.baseURL.absoluteString)
            try await self.setTranslateApi(server.translateApiURL)

            self.delegate.onReady()
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
