import Foundation

// MARK: JS 调用 Swift 时的通道名称

enum eventName {
    case updateContent
    case updateDoc
    case updateDocWithNode
    case updateDrawing
    case updateCurrentDocUUID
    case updateNode
    case message
    case pageLoaded
    case downloadFile
    case runCode
    case updateSelectionType
    case unknown(_ s: String)

    static func from(_ s: String) -> Self {
        switch s {
        case "updateContent":
            return .updateContent
        case "updateDoc":
            return .updateDoc
        case "updateDocWithNode":
            return .updateDocWithNode
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
        case "updateNode":
            return .updateNode
        case "message":
            return .message
        case "updateCurrentDocUUID":
            return .updateCurrentDocUUID
        default:
            return .unknown(s)
        }
    }

    var name: String {
        String(describing: self)
    }
}
