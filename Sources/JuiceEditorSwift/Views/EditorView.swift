import Foundation
import os
import SwiftUI
import MagicKit

public struct EditorView: SwiftUI.View, SuperLog {
    @State private var server: HTTPServer
    @State private var isServerStarted = false

    public let view = JSConfig.makeView(url: "about:blank")
    public var onGetNode: () -> Void = {
        os_log("GetNode")
    }

    public init(onGetNode: @escaping () -> Void) {
        self.server = HTTPServer(directoryPath: AppConfig.webAppPath, onGetNode: onGetNode)
    }

    public var body: some View {
        Group {
            if isServerStarted {
                view
                    .onAppear {
                        view.goto(server.baseURL)
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
            try? await self.setBaseUrl(server.baseURL.absoluteString)

            self.emitJuiceEditorReady()
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
    EditorView(onGetNode: {
        os_log("xxx")
    })
}
