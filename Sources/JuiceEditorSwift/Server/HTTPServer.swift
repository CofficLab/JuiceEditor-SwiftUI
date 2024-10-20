import Foundation
import NIOCore
import os
import SwiftUI
import Vapor
import MagicKit

public class HTTPServer: ObservableObject, SuperLog, SuperThread {
    let emoji = "📺"
    public var app: Application?
    public let directoryPath: String
    public let isDevMode = false
    public var port: Int = 49493
    public let vueDevServerURL = "http://localhost:5173"
    public var delegate: EditorDelegate
    
    @Published public var isRunning: Bool = false
    @Published public var currentPort: Int?

    var baseURL: URL {
        return URL(string: "http://localhost:\(currentPort ?? port)")!
    }

    public let logger = Logger(subsystem: "com.yourcompany.JuiceEditorSwift", category: "HTTPServer")

    public init(directoryPath: String, delegate: EditorDelegate) {
        self.directoryPath = directoryPath
        self.delegate = delegate
    }

    private func configureRoutes(app: Application) throws {
        if isDevMode {
            self.dev(app: app)
        } else {
            self.prod(app: app)
        }
        
        self.getNode(app: app)
        self.translate(app: app)
    }

    public func start() throws {
        var currentPort = port
        var serverStarted = false

        while !serverStarted && currentPort < port + 100 { // Try 100 ports
            do {
                self.app = Application(.production)
                
                guard let app = self.app else {
                    throw HTTPServerError.appNotInitialized
                }
                
                // Set the log level to critical
                app.logger.logLevel = .critical
                app.environment.arguments = ["vapor"]
                
                try configureRoutes(app: app)
                
                app.http.server.configuration.port = currentPort
                
                try app.start()
                serverStarted = true
                
                self.main.async {
                    self.emitStarted()
                    self.port = currentPort
                    self.isRunning = true
                }
                
                os_log("\(self.t)Server started on port \(currentPort) 🎉🎉🎉")
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

    public func startServer() {
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let webAppPath = currentDirectoryPath + "/WebApp"

        emitLog("Attempting to start server in debug mode")
        emitLog("WebApp path: \(webAppPath)")
        emitLog("Dev mode: \(isDevMode)")
        
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

// MARK: Event Name

extension Notification.Name {
    static let httpServerLog = Notification.Name("httpServerLog")
    static let httpServerStarted = Notification.Name("httpServerStarted")
}

// MARK: Emitter 

extension HTTPServer {
    public func emitLog(_ log: String) {
        NotificationCenter.default.post(name: .httpServerLog, object: log)
    }

    public func emitStarted() {
        NotificationCenter.default.post(name: .httpServerStarted, object: nil)
    }
}
