import Foundation
import os
import SwiftUI
import MagicKit

public struct EditorView: SwiftUI.View, SuperLog {
    let emoji = "📄"
    
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
    }
}

// MARK: Event Handler

extension EditorView {
    func onJSReady(_ n: Notification) {
        Task {
            try await self.setBaseUrl(server.baseURL.absoluteString)
            try await self.setTranslateApi(server.translateApiURL)

            self.emitJuiceEditorReady()
            self.delegate.onReady()
        }
    }

    func onServerStarted(_ n: Notification) {
        isServerStarted = true
    }

    func onJSCallUpdateDoc(_ n: Notification) {
        let html = n.userInfo?["html"] as? String
        
        if let html = html {
            delegate.onUpdateDoc(html)
        }
    }
}

// MARK: Event Name

extension Notification.Name {
    public static let JuiceEditorReady = Notification.Name("JuiceEditorReady")
}

// MARK: Event Emitter

extension EditorView {
    func emitJuiceEditorReady() {
        NotificationCenter.default.post(name: .JuiceEditorReady, object: nil)
    }
}

#Preview {
    EditorView()
}
