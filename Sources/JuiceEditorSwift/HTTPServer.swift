import Foundation
import NIOCore
import os
import SwiftUI
import Vapor

public class HTTPServer {
    private let app: Application
    private let directoryPath: String
    private let isDevMode: Bool
    private let vueDevServerURL: String
    private var port: Int

    private let logger = Logger(subsystem: "com.yourcompany.JuiceEditorSwift", category: "HTTPServer")

    public init(directoryPath: String, port: Int = 8080, isDevMode: Bool = false, vueDevServerURL: String = "http://localhost:5173") throws {
        self.directoryPath = directoryPath
        self.isDevMode = isDevMode
        self.vueDevServerURL = vueDevServerURL
        self.port = port
        self.app = Application(.development)

        try configureRoutes()
    }

    private func configureRoutes() throws {
        // 首先添加日志中间件，确保所有请求都被记录
        app.middleware.use(LoggingMiddleware(logger: logger))

        if isDevMode {
            // 明确定义根路径路由
            app.get { req -> ClientResponse in
                self.logger.info("Processing root request in dev mode")
                return try await self.handleDevModeRequest(req, path: "/index.html")
            }

            // 定义通配符路由
            app.get("**") { req -> ClientResponse in
                self.logger.info("Processing wildcard request in dev mode: \(req.url.string)")
                return try await self.handleDevModeRequest(req, path: req.url.path)
            }
        } else {
            // 生产模式：提供静态文件
            app.middleware.use(FileMiddleware(publicDirectory: directoryPath + "/dist"))

            app.get { req -> Response in
                self.logger.info("Received request for root, redirecting to index.html")
                return req.redirect(to: "/index.html")
            }
        }

        // 这里可以添加其他 API 路由
    }

    // 添加一个辅助方法来处理开发模式的请求
    private func handleDevModeRequest(_ req: Request, path: String) async throws -> ClientResponse {
        let client = req.client
        var url = self.vueDevServerURL + path
        if let query = req.url.query {
            url += "?" + query
        }
        if let fragment = req.url.fragment {
            url += "#" + fragment
        }
        self.logger.info("Forwarding to: \(url)")
        return try await client.get(URI(string: url))
    }

    public func start() throws {
        var currentPort = port
        var serverStarted = false

        while !serverStarted && currentPort < port + 100 { // Try 100 ports
            do {
                app.http.server.configuration.port = currentPort
                try app.start()
                serverStarted = true
                self.port = currentPort // 更新成功的端口
                logger.info("Server started on port \(currentPort)")
            } catch let error as NIOCore.IOError where error.errnoCode == EADDRINUSE {
                logger.warning("Port \(currentPort) is in use, trying next port")
                currentPort += 1
            } catch {
                logger.error("Unexpected error: \(error.localizedDescription)")
                logger.error("Error type: \(type(of: error))")
                logger.error("Error details: \(String(describing: error))")
                throw error
            }
        }

        if !serverStarted {
            throw HTTPServerError.noAvailablePort
        }
    }

    public func run() throws {
        try app.run()
    }

    deinit {
        app.shutdown()
    }
}

enum HTTPServerError: Error {
    case noAvailablePort
}

struct LoggingMiddleware: Middleware {
    let logger: os.Logger

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        logger.info("Received \(request.method.string) request for \(request.url.path)")
        return next.respond(to: request)
    }
}

#Preview {
    DebugView()
}
