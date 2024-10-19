import MagicKit
import OSLog
import SwiftUI
import WebKit

/// 与JS通信
class JSHandler: NSObject, WKScriptMessageHandler, SuperThread, SuperLog {
    let emoji = "📶"
    let notification = NotificationCenter.default

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let verbose = false

        if message.name == "updateHtml" {
            let html = message.body as! String

            self.emitJSCallUpdateHtml(html)
        } else if message.name == "sendMessage" {
            let data = message.body as! [String: Any]
            let channel = eventName.from(data["channel"] as! String)

            if verbose {
                os_log("\(self.t)JS 消息通道：\(channel.name)")
            }

            switch channel {
            case .downloadFile:
                downloadFile(message: message)
            case .pageLoaded:
                pageLoaded(message: message)
            case .runCode:
                runCode(message: message)
            case .updateContent:
                self.updateNode(message: message)
            case .updateDoc:
                self.updateDoc(message: message)
            case .updateDocWithNode:
                self.updateDocWithNode(message: message)
            case .updateDrawing:
                updateDrawing(message: message)
            case .updateSelectionType:
                updateSelectionType(message: message)
            case .updateNode:
                updateNode(message: message)
            case .message:
                printMessage(message)
            case .updateCurrentDocUUID:
                updateCurrentDocUUID(message: message)
            case let .unknown(c):
                os_log(.error, "\(self.t)JS 消息来自未知通道：\(c)")
                os_log(.error, "\(data)")
            }
        } else {
            os_log(.error, "收到JS发送的消息但未处理：\(message.name)")
        }
    }

    // MARK: Handler

    private func updateNode(message: WKScriptMessage) {
        let verbose = true
        let data = message.body as! [String: String]

        if verbose {
            os_log("\(self.t)UpdateNode")
            data.keys.forEach({
                os_log("\($0): \(data[$0]! as String)")
            })
        }

        self.notification.post(name: .jsCallUpdateDoc, object: nil, userInfo: data)
    }

    private func updateDoc(message: WKScriptMessage) {
        let verbose = false
        let printKeys = false
        let data = message.body as! [String: Any]

        if verbose {
            os_log("\(self.t)UpdateDoc")

            if printKeys {
                data.keys.forEach({
                    let key = $0
                    let value = String(describing: data[$0]!)
                    let valueDisplay = value.count > 100 ? "\(value.prefix(100))...\(value.count)" : value
                    os_log("  ➡️ \(key): \(valueDisplay)")
                })
            }
        }

        self.notification.post(name: .jsCallUpdateDoc, object: nil, userInfo: data)
    }

    private func updateCurrentDocUUID(message: WKScriptMessage) {
        let verbose = false
        let data = message.body as! [String: String]

        if verbose {
            os_log("\(self.t)UpdateCurrentDocUUID")
            data.keys.forEach({
                os_log("\($0): \(data[$0]! as String)")
            })
        }

        self.notification.post(name: .jsCallUpdateCurrentDocUUID, object: nil, userInfo: data)
    }

    private func updateDocWithNode(message: WKScriptMessage) {
        let verbose = false
        let data = message.body as! [String: String]

        if verbose {
            os_log("\(self.t)UpdateDocWithNode")
            data.keys.forEach({
                os_log("\($0): \(data[$0]! as String)")
            })
        }

        self.notification.post(name: .jsCallUpdateDocWithNode, object: nil, userInfo: data)
    }

    private func updateSelectionType(message: WKScriptMessage) {
        os_log("\(self.t)JS Said: updateSelectionType")

        let data = message.body as! [String: String]

        self.notification.post(name: .jsCallUpdateSelectionType, object: nil, userInfo: data)
    }

    private func pageLoaded(message: WKScriptMessage, verbose: Bool = false) {
        if verbose {
            os_log("\(self.t)JS Said: Ready")
        }

        self.notification.post(name: .jsReady, object: nil)
    }

    private func downloadFile(message: WKScriptMessage) {
        os_log("\(self.t)JS Said: DownloadFile")

        let data = message.body as! [String: String]

        downloadFile(base64: data["base64"] ?? "", name: data["name"] ?? "")
    }

    private func updateDrawing(message: WKScriptMessage) {
        os_log("\(self.t)JS Said: UpdateDrawing")

        self.notification.post(name: .jsCallUpdateDrawing, object: nil, userInfo: message.body as! [String: String])
    }

    private func runCode(message: WKScriptMessage) {
        let data = message.body as! [String: String]
        JobRunCode().run(lan: languages.fromString(data["lan"]!), code: data["code"]!, completion: {
            self.notification.post(name: .jsRunCodeResult, object: nil, userInfo: ["output": $0])
        })
    }

    private func downloadFile(base64: String, name: String) {
        let verbose = false

        if verbose {
            os_log("\(self.t)Download File")
            os_log("\(base64)")
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

            do {
                try base64Data.write(to: url.appendingPathComponent(name))
                print("保存成功")
            } catch {
                print("保存失败 -> \(error)")
            }
        } else {
        }
    }

    private func printMessage(_ message: WKScriptMessage) {
        let verbose = false

        let data = message.body as! [String: String]
        let m = data["message"]!

        if verbose {
            os_log("\(self.t)JS Message 🫧🫧🫧 -> \(m)")
        }
    }
}

// MARK: JS

extension JSHandler {
    func emitJSCallUpdateHtml(_ html: String) {
        DispatchQueue.main.async {
            self.notification.post(name: .jsCallUpdateHtml, object: nil, userInfo: [
                "html": html,
            ])
        }
    }
}

extension Notification.Name {
  static let jsReady = Notification.Name("jsReady")
  static let jsCallUpdateDoc = Notification.Name("jsCallUpdateDoc")
  static let jsCallUpdateHtml = Notification.Name("jsCallUpdateHtml")
  static let jsCallUpdateDocWithNode = Notification.Name("jsCallUpdateDocWithNode")
  static let jsCallUpdateSelectionType = Notification.Name("jsCallUpdateSelectionType")
  static let jsCallUpdateDrawing = Notification.Name("jsCallUpdateDrawing")
  static let jsCallUpdateContent = Notification.Name("jsCallUpdateContent")
  static let jsCallUpdateCurrentDocUUID = Notification.Name("jsCallUpdateCurrentDocUUID")
  static let jsCallRunCode = Notification.Name("jsCallRunCode")
  static let jsCallDownloadFile = Notification.Name("jsCallDownloadFile")
  static let jsRunCodeResult = Notification.Name("jsRunCodeResult")
  static let RunJavaScriptTextInputPanelWithPrompt = Notification.Name("RunJavaScriptTextInputPanelWithPrompt")
}
