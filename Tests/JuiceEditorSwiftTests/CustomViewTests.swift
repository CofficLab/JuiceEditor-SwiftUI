import XCTest
import SwiftUI
@testable import JuiceEditorSwift

final class CustomViewTests: XCTestCase {
    func testCustomViewInitialization() {
        let text = "Test"
        let backgroundColor = Color.red
        
        let customView = DebugView(text: text, backgroundColor: backgroundColor)
        
        XCTAssertEqual(customView.text, text)
        XCTAssertEqual(customView.backgroundColor, backgroundColor)
    }
    
    func testCustomViewDefaultBackgroundColor() {
        let text = "Test"
        
        let customView = DebugView(text: text)
        
        XCTAssertEqual(customView.backgroundColor, .blue)
    }
}
