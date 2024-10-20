import Foundation

public struct WildNode: Codable {
    var type: String = SuperNodeType.root.rawValue
    var html: String? = nil
    var text: String? = nil
    var attrs: [String: AttributeValue]?

    var uuid: String {
        if let attrs = self.attrs {
            return attrs["uuid"]?.stringValue ?? ""
        }

        return ""
    }

    var parentId: String? {
        if let attrs = self.attrs {
            return attrs["parent"]?.stringValue ?? nil
        }

        return nil
    }

    var title: String {
        if let attrs = self.attrs {
            return attrs["title"]?.stringValue ?? ""
        }

        return ""
    }

    func isDoc() -> Bool {
        return self.type == "doc"
    }
    
    func isRoot() -> Bool {
        return self.type == "root"
    }

    func isP() -> Bool {
        return self.type == "p"
    }

    enum CodingKeys: String, CodingKey {
        case type, html, text, attrs
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(html, forKey: .html)
        try container.encodeIfPresent(text, forKey: .text)
        try container.encodeIfPresent(attrs, forKey: .attrs)
    }
    
    init(type: SuperNodeType) {
        self.type = type.rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(String.self, forKey: .type)
        html = try container.decodeIfPresent(String.self, forKey: .html)
        text = try container.decodeIfPresent(String.self, forKey: .text)
        attrs = try container.decodeIfPresent([String: AttributeValue].self, forKey: .attrs)
    }

    func toJSON() -> String {
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
    mutating func setType(_ type: String) {
        self.type = type
    }

    mutating func setAttrs(_ attrs: [String: AttributeValue]) {
        self.attrs = attrs
    }

    mutating func setText(_ text: String) {
        self.text = text
    }

    mutating func setHtml(_ html: String?) {
        self.html = html
    }
    
    mutating func setUUID(_ uuid: String?) {
        if let uuid = uuid {
            if self.attrs == nil {
                self.attrs = [:]
            }

            self.attrs?["uuid"] = AttributeValue.string(uuid)
        } else {
            self.attrs?.removeValue(forKey: "uuid")
        }
    }

    mutating func setParentId(_ parentId: String?) -> Self     {
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

    mutating func setTitle(_ title: String) {
        if self.attrs == nil {
            self.attrs = [:]
        }

        self.attrs?["title"] = AttributeValue.string(title)
    }
}

// MARK: Parent

extension WildNode {
    func appendTo(_ parentId: String) -> WildNode {
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
    static func fromFile(_ url: URL) throws -> WildNode {
        var node = WildNode(type: .root)

//        let data = try Data(contentsOf: url)
//        node = try JSONDecoder().decode(WildNode.self, from: data)
//        node = node.appendTo(IdeaConfig.privateRootId)

        return node
    }
}
