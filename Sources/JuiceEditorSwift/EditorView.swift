import os
import SwiftUI
import Foundation

public struct EditorView: SwiftUI.View {
    @StateObject private var server = HTTPServer(directoryPath: AppConfig.webAppPath)
    @State private var showDebugView = false
    @State private var isServerStarted = false

    let view = JSConfig.makeView(url: "about:blank")
    
    public init() {}
    
    public var body: some View {
        VStack {
            Button("Show Debug View") {
                showDebugView = true
            }

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
        }
        .popover(isPresented: $showDebugView) {
            DebugView()
        }
    }
}

// MARK: Actions

extension EditorView {
}

#Preview {
    EditorView()
}
