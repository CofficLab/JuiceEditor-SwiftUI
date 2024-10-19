import SwiftUI
import JuiceEditorSwift

public struct ContentView: View {
    @State private var serverStarted = false
    
    public var body: some View {
        VStack(spacing: 20) {
            Text("JuiceEditor Test App")
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            CustomView(text: "Hello from JuiceEditor Test App!")
            
            Button(serverStarted ? "Server Running" : "Start Server") {
                if !serverStarted {
                    CustomView.startServer(directoryPath: "/path/to/your/project", isDevMode: true)
                    serverStarted = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(serverStarted)
            
            if serverStarted {
                Text("Server is running. Check the console for details.")
                    .foregroundColor(.green)
            }
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color.yellow.opacity(0.2))
    }
}

#Preview {
    ContentView()
}
