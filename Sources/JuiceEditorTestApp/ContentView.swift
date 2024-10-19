import SwiftUI
import JuiceEditorSwift
import os

public struct ContentView: View {
    @State private var serverStarted = false
    @State private var port = 8080
    @State private var actualPort: Int?
    
    private let logger = Logger(subsystem: "com.yourcompany.JuiceEditorTestApp", category: "ContentView")
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("JuiceEditor Test App")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            DebugView()
        }
    }
}

#Preview {
    ContentView()
}
