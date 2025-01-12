import Foundation
import MagicKit
import NIOCore
import os
import SwiftUI
import Vapor

public class HTTPServer: ObservableObject, SuperLog, SuperThread {
    public static let emoji = Config.rootEmoji + " 📺"

    public var app: Application?
    public let logger = Config.makeLogger("HttpServer")
    public let directoryPath: String
    public let isDevMode = false
    public var port: Int = 49493
    public let vueDevServerURL = "http://localhost:5173"
    public var delegate: EditorDelegate
    public var chatApi: String = ""
    public var drawIoLink: String = ""
    public var verbose: Bool
    public var baseURL: URL { URL(string: "http://localhost:\(port)")! }

    public init(directoryPath: String, delegate: EditorDelegate, verbose: Bool) {
        self.directoryPath = directoryPath
        self.delegate = delegate
        self.verbose = verbose
    }

    private func configureRoutes(app: Application) throws {
        if isDevMode {
            self.dev(app: app)
        } else {
            self.prod(app: app)
        }

        self.getNode(app: app, verbose: self.verbose)
        self.chat(app: app)
    }

    private func start(verbose: Bool = true) throws {
        if verbose {
            os_log("\(self.t)Start")
        }
        
        var currentPort = port
        var serverStarted = false

        while !serverStarted && currentPort < port + 100 { // Try 100 ports
            do {
                self.app = Application(.production)

                guard let app = self.app else {
                    throw HTTPServerError.appNotInitialized
                }

                app.logger.logLevel = .critical
                app.environment.arguments = ["vapor"]

                try configureRoutes(app: app)

                app.http.server.configuration.port = currentPort

                try app.start()
                serverStarted = true

               self.main.async {
                   self.port = currentPort
                   self.chatApi = self.baseURL.absoluteString + "/api/chat"
                   self.drawIoLink = self.baseURL.absoluteString + "/draw/index.html?"
                   self.emitStarted()
               }

                if verbose {
                    os_log("\(self.t)Server started on port \(currentPort) 🎉🎉🎉")
                }
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
    
    public func startServer(verbose: Bool) {
        bg.async {
            do {
                try self.start(verbose: verbose)
            } catch {
                os_log(.error, "\(self.t)Failed to start server: \(error)")
            }
        }
    }

    deinit {
        app?.shutdown()
    }
}

enum HTTPServerError: Error {
    case noAvailablePort
    case appNotInitialized
}

// MARK: Event Name

extension Notification.Name {
    static let httpServerStarted = Notification.Name("httpServerStarted")
}

// MARK: Emitter

extension HTTPServer {
    public func emitStarted() {
        NotificationCenter.default.post(name: .httpServerStarted, object: nil)
    }
}
