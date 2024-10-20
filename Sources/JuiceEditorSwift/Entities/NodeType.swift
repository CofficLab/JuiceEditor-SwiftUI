import Foundation

// MARK: 节点类型

public enum NodeType: Equatable {
    case paragraph
    case heading1
    case heading2
    case heading3
    case heading4
    case heading5
    case heading6
    case unknown(_ s: String)

    static func from(_ s: String) -> Self {
        switch s {
        case "paragraph":
            return .paragraph
        case "heading1":
            return .heading1
        case "heading2":
            return .heading2
        case "heading3":
            return .heading3
        case "heading4":
            return .heading4
        case "heading5":
            return .heading5
        case "heading6":
            return .heading6
        default:
            return .unknown(s)
        }
    }

    var label: String {
        String(describing: self)
    }
    
    var name: String {
        switch self{
        case .heading1:
            "1号标题"
        case .heading2:
            "2号标题"
        case .heading3:
            "3号标题"
        case .heading4:
            "4号标题"
        case .heading5:
            "5号标题"
        case .heading6:
            "6号标题"
        case .paragraph:
            "正文"
        case .unknown(let s):
            "未知 \(s)"
        }
    }
}
