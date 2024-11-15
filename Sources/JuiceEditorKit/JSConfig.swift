import CloudKit
import OSLog
import SwiftData
import SwiftUI
import MagicKit
import WebKit

class JSConfig: ObservableObject {    
    static func makeView(url: String, verbose: Bool = false) -> MagicKit.WebView {
        if verbose {
            os_log("🛜 JSConfig::MakeView with -> \(url)")
        }
        
        return WebView(url: URL(string: url), config: getViewConfig(verbose: verbose))
    }
    
    static var publicDir = Bundle.main.url(forResource: "dist", withExtension: nil)

    static var htmlFile = Bundle.main.url(
        forResource: "index",
        withExtension: "html",
        subdirectory: "dist/juice-editor"
    )

    static func getViewConfig(verbose: Bool = false) -> WKWebViewConfiguration {
        let userContentController = WKUserContentController()
        let config = WKWebViewConfiguration()

        userContentController.add(JSHandler(verbose: verbose), name: "sendMessage")
        userContentController.add(JSHandler(verbose: verbose), name: "updateHtml")

        config.userContentController = userContentController
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        return config
    }
}
