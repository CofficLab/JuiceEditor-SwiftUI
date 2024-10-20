import Foundation
import NIOCore
import os
import SwiftUI
import Vapor
import MagicKit

public class HTTPServer: ObservableObject, SuperLog, SuperThread {
    private var app: Application?
    private let directoryPath: String
    private let isDevMode = true
    private var port: Int = 49493
    private let vueDevServerURL = "http://localhost:5173"
    
    @Published public var isRunning: Bool = false
    @Published public var currentPort: Int?

    var baseURL: URL {
        return URL(string: "http://localhost:\(currentPort ?? port)")!
    }

    private let logger = Logger(subsystem: "com.yourcompany.JuiceEditorSwift", category: "HTTPServer")

    public init(directoryPath: String) {
        self.directoryPath = directoryPath
    }

    private func configureRoutes() throws {
        guard let app = self.app else {
            throw HTTPServerError.appNotInitialized
        }
        
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
                self.app = Application(.development)
                guard let app = self.app else {
                    throw HTTPServerError.appNotInitialized
                }
                
                try configureRoutes()
                
                app.http.server.configuration.port = currentPort
                try app.start()
                serverStarted = true
                
                self.main.async {
                    self.port = currentPort
                    self.isRunning = true
                }
                
                os_log("\(self.t)Server started on port \(currentPort)")
            } catch let error as NIOCore.IOError where error.errnoCode == EADDRINUSE {
                logger.warning("\(self.t)Port \(currentPort) is in use, trying next port")
                currentPort += 1
                self.app?.shutdown()
                self.app = nil
            } catch {
                logger.error("\(self.t)Unexpected error: \(error.localizedDescription)")
                logger.error("\(self.t)Error type: \(type(of: error))")
                logger.error("\(self.t)Error details: \(String(describing: error))")
                throw error
            }
        }

        if !serverStarted {
            throw HTTPServerError.noAvailablePort
        }
    }

    public func run() throws {
        try app?.run()
    }

    deinit {
        app?.shutdown()
        self.isRunning = false // Set isRunning to false when server shuts down
    }

    public func startServer(isDevMode: Bool = false) {
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let webAppPath = currentDirectoryPath + "/WebApp"

        emitLog("Attempting to start server in debug mode")
        emitLog("WebApp path: \(webAppPath)")
        emitLog("Dev mode: \(isDevMode)")

        if !isDevMode {
            // 构建 Vue 项目
            let task = Process()
            task.currentDirectoryPath = webAppPath
            task.launchPath = "/usr/bin/env"
            task.arguments = ["npm", "run", "build"]

            do {
                try task.run()
                task.waitUntilExit()
            } catch {
                logger.error("Failed to build Vue project: \(error.localizedDescription)")
                return
            }
        }
        
        Task {
            do {
                try await self.startAsync(port: port)
                self.main.async {
                    self.isRunning = true
                    self.currentPort = self.port
                }
            } catch {
                emitLog("Failed to start server: \(error.localizedDescription)")
                self.main.async {
                    self.isRunning = false
                    self.currentPort = nil
                }
            }
        }
    }

    private func startAsync(port: Int) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try self.start()
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}

enum HTTPServerError: Error {
    case noAvailablePort
    case appNotInitialized
}

struct LoggingMiddleware: Middleware {
    let logger: os.Logger

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        logger.info("Received \(request.method.string) request for \(request.url.path)")
        return next.respond(to: request)
    }
}

// MARK: Event Name

extension Notification.Name {
    static let httpServerLog = Notification.Name("httpServerLog")
}

// MARK: Emitter 

extension HTTPServer {
    public func emitLog(_ log: String) {
        NotificationCenter.default.post(name: .httpServerLog, object: log)
    }
}

#Preview {
    DebugView()
}
