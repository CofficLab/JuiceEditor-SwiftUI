import Foundation
import os
import SwiftUI
import MagicKit

public struct EditorView: SwiftUI.View, SuperLog {
    public static let defaultDelegate = DefaultDelegate()
    
    @State private var server: HTTPServer
    @State private var isServerStarted = false

    public let webView = JSConfig.makeView(url: "about:blank")
    public let delegate: EditorDelegate

    public init(delegate:  EditorDelegate = EditorView.defaultDelegate) {
        self.delegate = delegate
        self.server = HTTPServer(directoryPath: AppConfig.webAppPath, onGetNode: delegate.getNode)
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
                        server.startServer(isDevMode: true)
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .httpServerStarted)) { _ in
            isServerStarted = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .jsReady), perform: onJSReady)
    }
}

// MARK: Event Handler

extension EditorView {
    func onJSReady(_ n: Notification) {
        Task {
            try await self.setBaseUrl(server.baseURL.absoluteString)

            self.emitJuiceEditorReady()
            self.delegate.onReady()
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
