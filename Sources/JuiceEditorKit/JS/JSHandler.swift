import MagicKit
import OSLog
import SwiftUI
import WebKit

/// Communicate with JS
class JSHandler: NSObject, WKScriptMessageHandler, SuperThread, SuperLog {
    static let emoji = Config.rootEmoji + " 📶"
    let notification = NotificationCenter.default
    let logger: MagicLogger
    var verbose = true

    init(verbose: Bool = false, logger: MagicLogger) {
        self.verbose = verbose
        self.logger = logger
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "sendMessage" {
            let data = message.body as! [String: Any]
            let channel = JSEvent.from(data["channel"] as! String)

            switch channel {
            case .loading:
                loading(message: message)
            case .configChanged:
                configChanged(message: message)
            case .downloadFile:
                downloadFile(message: message)
            case .pageLoaded:
                logger.info("JS Said: Ready")
                self.notification.post(name: .jsReady, object: nil)
            case .runCode:
                runCode(message: message)
            case .updateArticle:
                self.updateArticle(message: message)
            case .updateNodes:
                self.updateNodes(message: message)
            case .updateDrawing:
                updateDrawing(message: message)
            case .updateSelectionType:
                updateSelectionType(message: message)
            case .message:
                printMessage(message)
            case .debug:
                printDebugMessage(message)
            case let .unknown(c):
                os_log(.error, "\(self.t)JS 消息来自未知通道：\(c)")
                os_log(.error, "\(data)")
            }
        } else {
            os_log(.error, "收到JS发送的消息但未处理：\(message.name)")
        }
    }

    // MARK: Handler

    private func loading(message: WKScriptMessage) {
        let data = message.body as! [String: Any]
        self.notification.post(name: .jsLoading, object: nil, userInfo: data)
    }

    private func configChanged(message: WKScriptMessage) {
        let data = message.body as! [String: Any]
        self.notification.post(name: .jsCallConfigChanged, object: nil, userInfo: data)
    }

    private func updateArticle(message: WKScriptMessage) {
        let data = message.body as! [String: Any]

        self.notification.post(name: .jsCallUpdateArticle, object: nil, userInfo: data)
    }

    private func updateNodes(message: WKScriptMessage) {
        let data = message.body as! [String: Any]

        self.notification.post(name: .jsCallUpdateNodes, object: nil, userInfo: data)
    }

    private func updateCurrentDocUUID(message: WKScriptMessage) {
        let data = message.body as! [String: String]

        if verbose {
            os_log("\(self.t)UpdateCurrentDocUUID")
            data.keys.forEach({
                os_log("\($0): \(data[$0]! as String)")
            })
        }

        self.notification.post(name: .jsCallUpdateCurrentDocUUID, object: nil, userInfo: data)
    }

    private func updateSelectionType(message: WKScriptMessage) {
        let data = message.body as! [String: String]

        self.notification.post(name: .jsCallUpdateSelectionType, object: nil, userInfo: data)
    }

    private func downloadFile(message: WKScriptMessage) {
        let data = message.body as! [String: String]

        downloadFile(base64: data["base64"] ?? "", name: data["name"] ?? "")
    }

    private func updateDrawing(message: WKScriptMessage) {
        self.notification.post(name: .jsCallUpdateDrawing, object: nil, userInfo: message.body as! [String: String])
    }

    private func runCode(message: WKScriptMessage) {
        let data = message.body as! [String: String]
        JobRunCode().run(lan: CodeLanguage.fromString(data["lan"]!), code: data["code"]!, completion: {
            self.notification.post(name: .jsRunCodeResult, object: nil, userInfo: ["output": $0])
        })
    }

    private func downloadFile(base64: String, name: String) {
        if verbose {
            os_log("\(self.t)Download File")
            os_log("\(base64)")
        }

        if name.isEmpty {
            let alert = NSAlert()
            alert.messageText = "Download Failed"
            alert.informativeText = "File name cannot be empty.\nThis should never happen. \n\nPlease report this bug."
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.runModal()
            return
        }

        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false

        if panel.runModal() == .OK, let url = panel.url {
            guard let base64Data = Data(base64Encoded: base64) else {
                print("Base64 decode failed")
                return
            }

            let targetURL = url.appendingPathComponent(name)

            do {
                try base64Data.write(to: targetURL)
                if verbose {
                    os_log(.info, "\(self.t)File downloaded successfully 🎉")
                }
            } catch {
                os_log(.error, "\(self.t)Error downloading file -> \(error.localizedDescription)")
                os_log(.error, "  ➡️ URL: \(targetURL.path)")
                os_log(.error, "\(self.t)\(error)")
            }
        } else {
        }
    }

    private func printMessage(_ message: WKScriptMessage) {
        let data = message.body as! [String: String]
        let m = data["message"]!

        if verbose {
            os_log("\(self.t)JS Message 🫧🫧🫧 -> \(m)")
        }

        print("JS Message 🫧🫧🫧 -> \(m)")
    }

    private func printDebugMessage(_ message: WKScriptMessage) {
        let data = message.body as! [String: String]
        let m = data["message"]!

        if verbose {
            os_log("\(self.t)JS Message 🫧🫧🫧 -> \(m)")
        }

        logger.info("JS Message 🫧🫧🫧 -> \(m)")
    }
}

// MARK: Event Name

extension Notification.Name {
    static let jsReady = Notification.Name("jsReady")
    static let jsLoading = Notification.Name("jsLoading")
    static let jsCallConfigChanged = Notification.Name("jsCallConfigChanged")
    static let jsCallUpdateArticle = Notification.Name("jsCallUpdateArticle")
    static let jsCallUpdateNodes = Notification.Name("jsCallUpdateNodes")
    static let jsCallUpdateSelectionType = Notification.Name("jsCallUpdateSelectionType")
    static let jsCallUpdateDrawing = Notification.Name("jsCallUpdateDrawing")
    static let jsCallUpdateContent = Notification.Name("jsCallUpdateContent")
    static let jsCallUpdateCurrentDocUUID = Notification.Name("jsCallUpdateCurrentDocUUID")
    static let jsCallRunCode = Notification.Name("jsCallRunCode")
    static let jsCallDownloadFile = Notification.Name("jsCallDownloadFile")
    static let jsRunCodeResult = Notification.Name("jsRunCodeResult")
    static let RunJavaScriptTextInputPanelWithPrompt = Notification.Name("RunJavaScriptTextInputPanelWithPrompt")
}

// MARK: Error

enum JSHandlerError: Error {
    case downloadFileFailed(String)
}

#Preview {
    EditorView(verbose: true)
        .frame(height: 800)
        .frame(width: 800)
}
