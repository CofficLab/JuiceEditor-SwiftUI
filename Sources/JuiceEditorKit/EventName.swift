import Foundation

// MARK: JS 调用 Swift 时的通道名称

enum eventName {
    case updateHTML
    case updateDocWithNode
    case updateDrawing
    case updateCurrentDocUUID
    case updateNodes
    case message
    case loading
    case pageLoaded
    case configChanged
    case downloadFile
    case runCode
    case updateSelectionType
    case debug
    case unknown(_ s: String)

    static func from(_ s: String) -> Self {
        switch s {
        case "updateHTML":
            return .updateHTML
        case "updateDocWithNode":
            return .updateDocWithNode
        case "updateDrawing":
            return .updateDrawing
        case "updateNodes":
            return .updateNodes
        case "pageLoaded":
            return .pageLoaded
        case "downloadFile":
            return .downloadFile
        case "runCode":
            return .runCode
        case "updateSelectionType":
            return .updateSelectionType
        case "message":
            return .message
        case "updateCurrentDocUUID":
            return .updateCurrentDocUUID
        case "configChanged":
            return .configChanged
        case "debug":
            return .debug
        case "loading":
            return .loading
        default:
            return .unknown(s)
        }
    }

    var name: String {
        String(describing: self)
    }
}
