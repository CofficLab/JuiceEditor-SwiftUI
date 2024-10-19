import os
import SwiftUI
import Vapor
import Foundation

class LogManager: ObservableObject {
    @Published var logs: [String] = []
    
    func addLog(_ message: String) {
        DispatchQueue.main.async {
            self.logs.append(message)
        }
    }
}

public struct DebugView: SwiftUI.View {
    @StateObject private var logManager = LogManager()
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
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(serverStarted)
            
            if serverStarted, let actualPort = actualPort {
                VStack {
                    Text("Server is running on port \(actualPort). Check the console for details.")
                        .foregroundColor(.green)
                    Link("Open in browser", destination: URL(string: "http://localhost:\(actualPort)")!)
                        .foregroundColor(.blue)
                        .padding(.top, 5)
                }
            }
            
            ConsoleView(logs: logManager.logs)
        }
        .padding()
        .frame(width: 600, height: 600)
        .background(Color.yellow.opacity(0.2))
    }

    public func startServer(port: Int = 8080, isDevMode: Bool = false) -> Int? {
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let webAppPath = currentDirectoryPath + "/WebApp"

        logManager.addLog("Attempting to start server in debug mode")
        logManager.addLog("WebApp path: \(webAppPath)")
        logManager.addLog("Dev mode: \(isDevMode)")
        logManager.addLog("Initial port: \(port)")

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
            server = try HTTPServer(directoryPath: webAppPath)
        } catch {
            logManager.addLog("Failed to initialize server: \(error.localizedDescription)")
            return nil
        }

        do {
            try server.start()
            return port // 返回成功启动的端口
        } catch {
            logManager.addLog("Failed to start server: \(error.localizedDescription)")
            return nil
        }
    }
}

struct CustomTextOutputStream: TextOutputStream {
    let callback: (String) -> Void
    
    func write(_ string: String) {
        callback(string)
    }
}

struct ConsoleView: SwiftUI.View {
    let logs: [String]
    
    var body: some SwiftUI.View {
        VStack(alignment: .leading) {
            Text("Console Output")
                .font(.headline)
                .padding(.bottom, 5)
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(logs.indices, id: \.self) { index in
                            Text(logs[index])
                                .font(.system(size: 12, design: .monospaced))
                                .id(index)
                        }
                    }
                }
                .onChange(of: logs.count) { _ in
                    proxy.scrollTo(logs.count - 1, anchor: .bottom)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.black.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    DebugView()
}
