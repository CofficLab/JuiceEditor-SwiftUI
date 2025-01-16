import Foundation
import MagicKit
import MagicWeb
import os
import SwiftUI

public struct EditorView: SwiftUI.View {
    public static let defaultDelegate = DefaultDelegate()

    @StateObject private var viewModel: EditorViewModel

    public let delegate: EditorDelegate
    public let verbose: Bool
    public var webView: MagicWebView {
        viewModel.webView
    }

    public init(delegate: EditorDelegate = EditorView.defaultDelegate, verbose: Bool) {
        if verbose {
            print("EditorView")
        }

        self.delegate = delegate
        self.verbose = verbose
        _viewModel = StateObject(wrappedValue: EditorViewModel(delegate: delegate, verbose: verbose))
    }

    public var body: some View {
        Group {
            if viewModel.isServerStarted {
                viewModel.webViewContainer
            } else {
                Text("Starting server...")
                    .onAppear {
                        viewModel.startServer()
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .httpServerStarted), perform: viewModel.onServerStarted)
        .onReceive(NotificationCenter.default.publisher(for: .jsReady), perform: viewModel.onJSReady)
        .onReceive(NotificationCenter.default.publisher(for: .jsCallUpdateArticle), perform: viewModel.onJSCallUpdateArticle)
        .onReceive(NotificationCenter.default.publisher(for: .jsCallUpdateNodes), perform: viewModel.onJSCallUpdateNodes)
        .onReceive(NotificationCenter.default.publisher(for: .jsCallConfigChanged), perform: viewModel.onConfigChanged)
        .onReceive(NotificationCenter.default.publisher(for: .jsLoading), perform: viewModel.onLoading)
    }
}

// MARK: Action

extension EditorView {
    public func setContent(_ uuid: String) async throws {
        try await self.viewModel.setContentFromWeb(
            self.viewModel.server.baseURL.absoluteString + "/api/node/" + uuid + "/html",
            uuid: uuid,
            verbose: self.verbose
        )
    }
}

// MARK: Event Handler

extension EditorView {
    func onServerStarted(_ n: Notification) {
        viewModel.isServerStarted = true
    }
}

#Preview {
    EditorView(verbose: true)
        .frame(height: 800)
        .frame(width: 800)
}
