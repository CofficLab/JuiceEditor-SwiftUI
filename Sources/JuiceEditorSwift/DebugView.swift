import os
import SwiftUI
import Vapor

public struct DebugView: SwiftUI.View {
    @State public var serverStarted = false
    @State public var port = 8088
    @State public var actualPort: Int?
    
    public init() {}
    
    public let logger = Logger(subsystem: "com.yourcompany.JuiceEditorTestApp", category: "ContentView")

    public var body: some SwiftUI.View {
        VStack(spacing: 20) {
            Text("JuiceEditor Debug View")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            
            TextField("Port", value: $port, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 100)
            
            Button(serverStarted ? "Server Running" : "Start Server") {
                if !serverStarted {
                    if let startedPort = startServer(port: port, isDevMode: true) {
                        serverStarted = true
                        actualPort = startedPort
                    }
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(serverStarted)
            
            if serverStarted, let actualPort = actualPort {
                Text("Server is running on port \(actualPort). Check the console for details.")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color.yellow.opacity(0.2))
    }

    public func startServer(port: Int = 8080, isDevMode: Bool = false) -> Int? {
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let webAppPath = currentDirectoryPath + "/WebApp"

        print("Attempting to start server in debug mode")
        logger.debug("WebApp path: \(webAppPath)")
        logger.debug("Dev mode: \(isDevMode)")
        logger.debug("Initial port: \(port)")

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
                return nil
            }
        }

        let server: HTTPServer
        do {
            server = try HTTPServer(directoryPath: webAppPath, port: port, isDevMode: isDevMode)
        } catch {
            print("Failed to initialize server: \(error.localizedDescription)")
            return nil
        }

        do {
            try server.start()
            return port // 返回成功启动的端口
        } catch {
            print("Failed to start server: \(error.localizedDescription)")
            return nil
        }
    }
}

#Preview {
    DebugView()
}
