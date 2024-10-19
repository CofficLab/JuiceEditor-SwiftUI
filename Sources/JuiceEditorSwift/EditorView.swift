import os
import SwiftUI
import Foundation

public struct EditorView: SwiftUI.View {
    @StateObject private var server = HTTPServer(directoryPath: AppConfig.webAppPath)
    @State private var showDebugView = false

    let view = JSConfig.makeView(url: "http://127.0.0.1:8081/index.html")
    
    public init() {}
    
    public var body: some View {
        VStack {
            Button("Show Debug View") {
                showDebugView = true
            }

            Group {
                if server.isRunning {
                    view
                        .onAppear {
                            view.goto(URL(string: "http://127.0.0.1:8088/index.html")!)
                        }
                } else {
                    Text("Starting server...")
                        .onAppear {
                            server.startServer(isDevMode: true)
                        }
                }
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
