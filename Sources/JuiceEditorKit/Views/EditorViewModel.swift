import SwiftUI
import MagicKit
import Foundation
import MagicWeb
import OSLog

/// EditorViewModel 负责管理 EditorView 的核心状态和资源
/// 
/// 使用 lazy 初始化确保 webView 只被创建一次
/// 将所有状态和资源管理集中在 ViewModel 中，避免在视图层发生重复初始化
public class EditorViewModel: ObservableObject {
    // 添加静态实例存储
    private static var sharedWebView: MagicWebView?
    
    let delegate: EditorDelegate
    let verbose: Bool
    let server: HTTPServer
    let logger: MagicLogger
    
    @Published var isServerStarted = false
    
    // 修改为使用静态实例
    private var _webView: MagicWebView {
        if Self.sharedWebView == nil {
            if self.verbose {
                logger.info("Creating WebView - \(Date())")
            }
            Self.sharedWebView = JSConfig.makeView(url: "about:blank", verbose: self.verbose, logger: logger)
        }
        return Self.sharedWebView!
    }
    
    var webView: MagicWebView {
        _webView
    }
    
    var webViewContainer: some View {
        webView
            .onAppear {
                if self.isServerStarted {
                    self.webView.goto("http://localhost:5173/".toURL())
                }
            }
    }
    
    init(delegate: EditorDelegate, verbose: Bool, logger: MagicLogger) {
        self.delegate = delegate
        self.verbose = verbose
        self.logger = logger
        self.server = HTTPServer(directoryPath: Config.webAppPath, delegate: delegate, verbose: verbose)
    }
    
    func startServer() {
        logger.info("Start Server")
        server.startServer(verbose: verbose)
    }
    
    func onServerStarted(_ notification: Notification) {
        logger.info("Server Started")
        isServerStarted = true
    }
    
    func onJSReady(_ n: Notification) {
        logger.info("Editor Page Ready")
        Task {
            do {
//                try await self.setChatApi(server.chatApi)
//                try await self.setDrawLink(server.drawIoLink)

//                self.delegate.onReady()
            } catch {
                os_log(.error, "\(error)")
            }
        }
    }
    

    func onJSCallUpdateArticle(_ n: Notification) {
        logger.info("EditorView.onJSCallUpdateArticle")
        let data = n.userInfo as? [String: Any]

        guard let data = data else {
            return
        }
        
        guard let nodeData = data["node"] as? [String: Any] else {
            return
        }

        Task {
            do {
                let node = try await EditorNode.getEditorNodeFromData(nodeData, reason: "EditorView.onJSCallUpdateArticle", verbose: verbose)
                delegate.onUpdateNodes([node])
            } catch {
                os_log(.error, "\(error)")
            }
        }
    }
    
    func onJSCallUpdateNodes(_ n: Notification) {
        logger.info("EditorView.onJSCallUpdateNodes")
        let data = n.userInfo as? [String: Any]

        guard let data = data else {
            return
        }
//
//        Task {
//            do {
//                let nodes = try await EditorNode.getEditorNodesFromData(data, reason: "EditorView.onJSCallUpdateNodes", verbose: verbose)
//                delegate.onUpdateNodes(nodes)
//            } catch {
//                os_log(.error, "\(error)")
//            }
//        }
    }
    
    
    func onConfigChanged(_ n: Notification) {
        delegate.onConfigChanged()
    }

    func onLoading(_ n: Notification) {
        logger.info("EditorView.onLoading")
        let data = n.userInfo as? [String: Any]

        guard let data = data else {
            return
        }

//        delegate.onLoading(data["reason"] as! String)
    }
}

#Preview {
    EditorView(verbose: true)
        .frame(height: 800)
        .frame(width: 800)
}
