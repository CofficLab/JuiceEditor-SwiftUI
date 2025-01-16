import Foundation
import MagicKit
import MagicWeb
import os
import SwiftUI

public struct EditorView: SwiftUI.View, SuperEvent {
    public static let defaultDelegate = DefaultDelegate()

    @StateObject private var vm: EditorViewModel

    public let delegate: EditorDelegate
    public let verbose: Bool
    public let logger: MagicLogger
    public var webView: MagicWebView {
        vm.webView
    }

    public init(delegate: EditorDelegate = EditorView.defaultDelegate, verbose: Bool) {
        if verbose {
            print("EditorView")
        }

        self.delegate = delegate
        self.verbose = verbose
        
        let logger  = MagicLogger(app: "EditorView")
        self.logger = logger
        _vm = StateObject(wrappedValue: EditorViewModel(delegate: delegate, verbose: verbose, logger: logger))
    }

    public var body: some View {
        Group {
            VStack {
                if vm.isServerStarted {
                    vm.webViewContainer
                } else {
                    Text("Starting server...")
                        .onAppear {
                            vm.startServer()
                        }
                }
                
                logger.logView()
            }
        }
        .onAppear {
            logger.info("EditorView onAppear")
        }
        .onReceive(nc.publisher(for: .httpServerStarted), perform: vm.onServerStarted)
        .onReceive(nc.publisher(for: .jsReady), perform: vm.onJSReady)
        .onReceive(nc.publisher(for: .jsCallUpdateArticle), perform: vm.onJSCallUpdateArticle)
        .onReceive(nc.publisher(for: .jsCallUpdateNodes), perform: vm.onJSCallUpdateNodes)
        .onReceive(nc.publisher(for: .jsCallConfigChanged), perform: vm.onConfigChanged)
        .onReceive(nc.publisher(for: .jsLoading), perform: vm.onLoading)
    }
}

// MARK: Action

extension EditorView {
//    public func setContent(_ uuid: String) async throws {
//        try await self.vm.setContentFromWeb(
//            self.vm.server.baseURL.absoluteString + "/api/node/" + uuid + "/html",
//            uuid: uuid,
//            verbose: self.verbose
//        )
//    }
}

#Preview {
    EditorView(verbose: true)
        .frame(height: 800)
        .frame(width: 800)
}
