import SwiftUI
import MagicKit

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
        self.server = HTTPServer(delegate: delegate)
        
        setupServer()
    }
    
    private func setupServer() {
        if verbose {
            info("Starting HTTP Server")
        }
        
        server.startServer(verbose: verbose)
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
//        if message["channel"] as? String == "pageLoaded" {
//            Task { @MainActor in
//                self.isReady = true
//                self.delegate.onReady()
//            }
//        }
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
    
    // MARK: - Core APIs
    
    @discardableResult
    public func run(_ script: String) async throws -> Any {
        guard let webView = webView, isReady else {
            throw EditorError.notReady
        }

        return webView.evaluateJavaScript(script)
    }
    
    public func setContent(_ uuid: String) async throws {
        try await run("window.editor.setContent('\(uuid)')")
    }
    
    public func getContent() async throws -> String {
        guard let result = try await run("window.editor.getContent()") as? String else {
            throw EditorError.invalidResponse
        }
        return result
    }
    
    public func createArticle(_ title: String) async throws {
        try await run("window.editor.createArticle('\(title)')")
    }
}

// MARK: - Editor Errors

public enum EditorError: Error {
    case notReady
    case invalidResponse
    case evaluationFailed(String)
}

// MARK: - Previews

#Preview("All Features") {
    EditorPreview()
}
