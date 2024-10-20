import Foundation

public struct WildNode: Codable {
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
    
    public func isRoot() -> Bool {
        return self.type == "root"
    }

    public func isP() -> Bool {
        return self.type == "p"
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
}

// MARK: Set

extension WildNode {
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

    public mutating func setParentId(_ parentId: String?) -> Self     {
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

// MARK: Parent

extension WildNode {
    public func appendTo(_ parentId: String) -> WildNode {
        var newNode = self
        newNode = newNode.setParentId(parentId)
        if newNode.uuid == "" {
            newNode.setUUID(UUID().uuidString)
        }

        return newNode
    }
}

// MARK: File

extension WildNode {
    public static func fromFile(_ url: URL) throws -> WildNode {
        var node = WildNode(type: .root)

//        let data = try Data(contentsOf: url)
//        node = try JSONDecoder().decode(WildNode.self, from: data)
//        node = node.appendTo(IdeaConfig.privateRootId)

        return node
    }
}
