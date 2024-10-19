import SwiftUI

public struct CustomView: View {
    private let text: String
    private let backgroundColor: Color
    
    public init(text: String, backgroundColor: Color = .blue) {
        self.text = text
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        Text(text)
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct CustomView_Previews: PreviewProvider {
    static var previews: some View {
        CustomView(text: "Hello, World!")
    }
}
