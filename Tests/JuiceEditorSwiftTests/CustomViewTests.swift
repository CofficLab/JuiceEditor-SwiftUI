import XCTest
import SwiftUI
@testable import JuiceEditorSwift

final class CustomViewTests: XCTestCase {
    func testCustomViewInitialization() {
        let text = "Test"
        let backgroundColor = Color.red
        
        let customView = CustomView(text: text, backgroundColor: backgroundColor)
        
        XCTAssertEqual(customView.text, text)
        XCTAssertEqual(customView.backgroundColor, backgroundColor)
    }
    
    func testCustomViewDefaultBackgroundColor() {
        let text = "Test"
        
        let customView = CustomView(text: text)
        
        XCTAssertEqual(customView.backgroundColor, .blue)
    }
}
