import Foundation
import OSLog
import MagicKit

public struct EditorNode: Codable, SuperLog {
    static var emoji = "🌰"
    public var emoji = EditorNode.emoji
    public var type: String = SuperNodeType.root.rawValue
    public var html: String? = nil
    public var text: String? = nil
    public var attrs: [String: AttributeValue]?

    public var uuid: String {
        if let attrs = self.attrs {
            return attrs["uuid"]?.stringValue ?? ""
        }

        return ""
    }

    public var parentId: String? {
        if let attrs = self.attrs {
            return attrs["parent"]?.stringValue ?? nil
        }

        return nil
    }

    public var title: String {
        if let attrs = self.attrs {
            return attrs["title"]?.stringValue ?? ""
        }

        return ""
    }

    public func isDoc() -> Bool {
        return self.type == "doc"
    }

    public enum CodingKeys: String, CodingKey {
        case type, html, text, attrs
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(html, forKey: .html)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(attrs, forKey: .attrs)
    }

    public init(type: SuperNodeType) {
        self.type = type.rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        html = try container.decodeIfPresent(String.self, forKey: .html)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        attrs = try container.decodeIfPresent([String: AttributeValue].self, forKey: .attrs)
    }

    public func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(self)
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            print("转换为 JSON 时出错: \(error)")
            return "{}"
        }
    }

    static func getWildNodeFromData(_ data: [String: Any]) async throws -> EditorNode {
        guard let jsNode = data["node"] as? [String: Any] else {
            let error = NSError(domain: "InvalidType", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected [String: Any]"])
            os_log(.error, "\(error.localizedDescription)")
            print(data)
            
            throw error
        }

        var node = EditorNode(type: .root)

        if let type = jsNode["type"] as? String {
            node.setType(type)
        }

        if let attrs = jsNode["attrs"] as? [String: Any] {
            // 将 Any 转换为 AttributeValue
            let convertedAttrs = attrs.mapValues { value -> AttributeValue in
                if let stringValue = value as? String {
                    return AttributeValue.string(stringValue)
                }

                if let numberValue = value as? Int {
                    return AttributeValue.int(numberValue)
                }

                // 根据需要添加其他类型的转换
                return AttributeValue.string(String(describing: value))
            }

            node.setAttrs(convertedAttrs)
        }
        
        if let uuid = jsNode["uuid"] as? String {
            node.setUUID(uuid)
        }
        
        if let title = jsNode["title"] as? String {
            node.setTitle(title)
        }

        if let text = jsNode["text"] as? String {
            node.setText(text)
        }

        if let html = jsNode["html"] as? String {
            node.setHtml(html)
        }

        return node
    }

    static func getWildNodesFromData(_ data: [String: Any]) async throws -> [EditorNode] {
        guard let jsNodes = data["nodes"] as? [[String: Any]] else {
            let error = NSError(domain: "InvalidType", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected an array of dictionaries"])
            os_log(.error, "\(error.localizedDescription)")
            print(data)
            
            throw error
        }

        var nodes = [EditorNode]()

        for block in jsNodes {
            await nodes.append(try EditorNode.getWildNodeFromData(block))
        }

        return nodes
    }
}

// MARK: Set

extension EditorNode {
    public mutating func setType(_ type: String) {
        self.type = type
    }

    public mutating func setAttrs(_ attrs: [String: AttributeValue]) {
        self.attrs = attrs
    }

    public mutating func setText(_ text: String) {
        self.text = text
    }

    public mutating func setHtml(_ html: String?) {
        self.html = html
    }

    public mutating func setUUID(_ uuid: String?) {
        if let uuid = uuid {
            if self.attrs == nil {
                self.attrs = [:]
            }

            self.attrs?["uuid"] = AttributeValue.string(uuid)
        } else {
            self.attrs?.removeValue(forKey: "uuid")
        }
    }

    public mutating func setParentId(_ parentId: String?) -> Self {
        if let parentId = parentId {
            if self.attrs == nil {
                self.attrs = [:]
            }

            self.attrs?["parent"] = AttributeValue.string(parentId)
        } else {
            self.attrs?.removeValue(forKey: "parent")
        }

        return self
    }

    public mutating func setTitle(_ title: String) {
        if self.attrs == nil {
            self.attrs = [:]
        }

        self.attrs?["title"] = AttributeValue.string(title)
    }
}
