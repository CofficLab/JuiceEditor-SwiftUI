import XCTest
import SwiftUI
@testable import JuiceEditorSwift

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

final class CustomViewUITests: XCTestCase {
    func testCustomViewUI() {
        let text = "Test"
        let backgroundColor = Color.green
        
        let customView = CustomView(text: text, backgroundColor: backgroundColor)
        
        #if canImport(UIKit)
        let hostingController = UIHostingController(rootView: customView)
        let view = hostingController.view
        #elseif canImport(AppKit)
        let hostingView = NSHostingView(rootView: customView)
        let view = hostingView
        #endif
        
        XCTAssertNotNil(view)
        
        // 这里我们可以添加更多的 UI 测试，比如检查视图的大小、颜色等
        // 但是请注意，由于 SwiftUI 的特性，进行详细的 UI 测试可能会比较困难
    }
}
