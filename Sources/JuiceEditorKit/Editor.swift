import MagicKit
import SwiftUI

@MainActor
public final class Editor: ObservableObject {
    // MARK: - Public Properties

    public let delegate: EditorDelegate
    @Published public private(set) var isReady = false
    @Published public private(set) var isServerStarted = false
    @Published public private(set) var webView: MagicWebView?

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
                .makeWebView(onCustomMessage: {
                    self.onCustomMessage($0)
                })
                .showLogView(false)
                .verboseMode(verbose)
        }
    }

    private func onCustomMessage(_ message: Any) {
        if verbose {
            debug("收到 WebView 消息: \(String(describing: message))")
        }

        if let message = message as? [String: Any] {
            if message["channel"] as? String == "pageLoaded" {
                Task { @MainActor in
                    self.isReady = true
                    self.delegate.onReady()
                }
            }
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
