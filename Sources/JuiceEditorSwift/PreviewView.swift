import SwiftUI

public struct PreviewView: SwiftUI.View {
    @State private var text = "Hello, JuiceEditor!"
    @State private var backgroundColor = Color.blue
    @State private var showServerWarning = false
    
    public var body: some SwiftUI.View {
        VStack {
            CustomView(text: text, backgroundColor: backgroundColor)
            
            TextField("Enter text", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            ColorPicker("Background Color", selection: $backgroundColor)
                .padding()
            
            Button("Start Server") {
                showServerWarning = true
                #if DEBUG
                print("Server start attempted in preview")
                #endif
            }
            .padding()
            
            if showServerWarning {
                Text("Server cannot be started in preview.\nPlease run in a full app environment.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    PreviewView()
}
