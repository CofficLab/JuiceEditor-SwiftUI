import CloudKit
import OSLog
import SwiftData
import SwiftUI
import MagicKit
import WebKit
import MagicWeb

class JSConfig: ObservableObject {    
    static func makeView(url: String, verbose: Bool) -> MagicWebView {
        print("JSConfig.makeView")
        return MagicWebView(url: URL(string: url), config: getViewConfig(verbose: verbose), verbose: verbose)
    }
    
    static var publicDir = Bundle.main.url(forResource: "dist", withExtension: nil)

    static var htmlFile = Bundle.main.url(
        forResource: "index",
        withExtension: "html",
        subdirectory: "dist/juice-editor"
    )

    static func getViewConfig(verbose: Bool) -> WKWebViewConfiguration {
        let userContentController = WKUserContentController()
        let config = WKWebViewConfiguration()

        userContentController.add(JSHandler(verbose: verbose), name: "sendMessage")

        config.userContentController = userContentController
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        return config
    }
}
