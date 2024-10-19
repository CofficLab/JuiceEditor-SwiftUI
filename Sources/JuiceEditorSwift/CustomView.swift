import SwiftUI
import Vapor

public struct CustomView: SwiftUI.View {
    let text: String
    let backgroundColor: Color
    
    public init(text: String, backgroundColor: Color = .blue) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
    
    public var body: some SwiftUI.View {
        Text(text)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
    
    public static func startServer(isDevMode: Bool = false) {
        let currentDirectoryPath = FileManager.default.currentDirectoryPath
        let webAppPath = currentDirectoryPath + "/WebApp"
        
        #if DEBUG
        print("Attempting to start server in debug mode")
        print("WebApp path: \(webAppPath)")
        print("Dev mode: \(isDevMode)")
        #endif
        
        do {
            let server = try HTTPServer(directoryPath: webAppPath, isDevMode: isDevMode)
            try server.start()
        } catch {
            #if DEBUG
            print("Failed to start server: \(error)")
            print("Error description: \(error.localizedDescription)")
            if let nsError = error as NSError? {
                print("Error domain: \(nsError.domain)")
                print("Error code: \(nsError.code)")
            }
            #endif
        }
    }
    
    public static func createPreviewView() -> some SwiftUI.View {
        PreviewView()
    }
}

#Preview {
    CustomView(text: "Hello, World!")
}
