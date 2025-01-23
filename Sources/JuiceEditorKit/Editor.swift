import MagicKit
import SwiftUI

@MainActor
public final class Editor: ObservableObject {
    // MARK: - Public Properties

    public let delegate: EditorDelegate
    @Published public private(set) var isReady = false
    @Published public private(set) var isServerStarted = false
    @Published public private(set) var webView: MagicWebView?
    @Published public private(set) var errorMessage: String?

    // MARK: - Private Properties

    private let server: HTTPServer
    internal let verbose: Bool

    // MARK: - Initialization

    public init(
        delegate: EditorDelegate = DefaultDelegate(),
        verbose: Bool = false
    ) {
        self.delegate = delegate
        self.verbose = verbose
        self.server = HTTPServer(delegate: delegate, verbose: verbose)

        setupServer()
    }

    private func setupServer() {
        server.startServer()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onServerStarted),
            name: .httpServerStarted,
            object: nil
        )
    }

    @objc private func onServerStarted() {
        Task { @MainActor in
            self.isServerStarted = true
            if verbose {
                info("Server Started")
            }

            self.webView = self.server.baseURL
                .makeWebView(onJavaScriptError: { s,i,ss in
                    self.setErrorMessage("JavaScript Error: \(s) \(i) \(ss)")
                }, onCustomMessage: {
                    self.onCustomMessage($0)
                })
                .showLogView(false)
                .verboseMode(false)
        }
    }

    private func onCustomMessage(_ message: Any) {
        if let message = message as? [String: Any] {
            let channel = message["channel"] as? String

            if channel == "pageLoaded" {
                Task { @MainActor in
                    self.isReady = true
                    try? await self.enableWebKit()
                    try? await self.disableDebugBar()
                    try? await self.setChatApi(self.server.chatApi)
                    self.delegate.onReady()
                }
            } else if channel == "debug" {
                let message = message["message"] as? String
                if let message = message, verbose {
                    debug("JS Message: " + message)
                }
            } else if channel == "updateNodes" {
                if verbose {
                    debug("updateNodes")
                }
                Task {
                    try? await self.delegate.onUpdateNodes(EditorNode.getEditorNodesFromData(message, reason: "Editor", verbose: false))
                }
            } else if channel == "updateArticle" {
                if verbose {
                    debug("updateArticle")
                }
            } else if channel == "updateSelectionType" {
                if verbose {
                    debug("updateSelectionType")
                }
            } else {
                warning("收到 WebView 消息: \(String(describing: message))")
            }
        } else {
            errorLog("Invalid message: \(String(describing: message))")
        }
    }

    // MARK: - Public View

    public func view(
        showTopBar: Bool = true,
        showLogView: Bool = false
    ) -> some View {
        EditorContent(
            editor: self,
            showTopBar: showTopBar,
            showLogView: showLogView
        )
    }
}

// MARK: Set

extension Editor {
    func setErrorMessage(_ message: String) {
        self.errorMessage = message
    }

    func setErrorMessageNil() {
        self.errorMessage = nil
    }
}

// MARK: - Editor Errors

public enum EditorError: Error, LocalizedError {
    case notReady
    case invalidResponse
    case evaluationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .notReady: return "Editor is not ready"
        case .invalidResponse: return "Invalid response"
        case let .evaluationFailed(message): return "Evaluation failed: \(message)"
        }
    }
}

// MARK: - Previews

#Preview("All Features") {
    EditorPreview()
}
