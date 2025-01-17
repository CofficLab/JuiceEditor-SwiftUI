import Foundation

enum EditorError: Error, LocalizedError {
    case webViewNotLoaded

    var errorDescription: String? {
        switch self {
        case .webViewNotLoaded:
            return "WebView not loaded"
        }
    }
}
