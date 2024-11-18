import Foundation

// MARK: JS 调用 Swift 时的通道名称

enum JSEvent {
    case updateDoc
    case updateNodes
    case updateDrawing
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
        case "updateDoc":
            return .updateDoc
        case "updateNodes":
            return .updateNodes
        case "updateDrawing":
            return .updateDrawing
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
