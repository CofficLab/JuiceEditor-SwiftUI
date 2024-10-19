import Foundation
import Vapor
import SwiftUI

public class HTTPServer {
    private let app: Application
    private let directoryPath: String
    private let isDevMode: Bool
    private let vueDevServerURL: String
    
    public init(directoryPath: String, isDevMode: Bool = false, vueDevServerURL: String = "http://localhost:5173") throws {
        self.directoryPath = directoryPath
        self.isDevMode = isDevMode
        self.vueDevServerURL = vueDevServerURL
        self.app = Application(.development)
        
        try configureRoutes()
    }
    
    private func configureRoutes() throws {
        if isDevMode {
            // 在开发模式下，将请求代理到 Vue 开发服务器
            app.get("**") { req -> ClientResponse in
                let client = req.client
                let url = self.vueDevServerURL + req.url.path
                return try await client.get(URI(string: url))
            }
        } else {
            // 生产模式：提供静态文件
            app.middleware.use(FileMiddleware(publicDirectory: directoryPath))
            
            app.get { req -> Response in
                return req.redirect(to: "/editor/index.html")
            }
        }
        
        // 这里可以添加其他 API 路由
    }
    
    public func start() throws {
        try app.run()
    }
    
    deinit {
        app.shutdown()
    }
}

#Preview {
    PreviewView()
}
