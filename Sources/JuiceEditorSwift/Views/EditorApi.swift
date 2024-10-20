import Foundation
import OSLog
import MagicKit

public extension EditorView {
    public func run(_ script: String) async throws -> Any {
        try await self.view.content.run(script)
    }

    func evaluateJavaScript(_ script: String) async throws -> Any {
        try await self.view.content.evaluateJavaScript(script)
    }
    
    // MARK: DEBUG
    
    public func printJSON(_ json: String) async throws -> Any {
        let verbose = true
        if verbose {
            os_log("\(self.t)PrintJSON 🛜🛜🛜 -> \(json)")
        }

        return try await run("api.doc.printJSON(`\(json)`)")
    }
    
    // MARK: GetJSONFromHTML
    
    public func getWildNodesFromHTML(_ html: String) async throws -> [WildNode] {
        let blocks = try await self.getBlocksFromHTML(html)
        var nodes = [WildNode]()
        
        for block in blocks {
            var node = WildNode(type: .root)
            
            if let type = block["type"] as? String {
                node.setType(type)
            }

            if let attrs = block["attrs"] as? [String: Any] {
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

            if let text = block["text"] as? String {
                node.setText(text)
            }
            
            if let html = block["html"] as? String {
                node.setHtml(html)
            }
            
            nodes.append(node)
        }
        
        return nodes
    }
    
    func getJSONFromHTML(_ html: String) async throws -> Any {
        let escapedHTML = html.replacingOccurrences(of: "`", with: "\\`")
        return try await run("api.node.getJSONFromHTML(`\(escapedHTML)`)")
    }
    
    public func getBlocksFromHTML(_ html:String) async throws -> [[String: Any]] {
        let escapedHTML = html.replacingOccurrences(of: "`", with: "\\`")
        let result = try await run("api.node.getBlocksFromHTML(`\(escapedHTML)`)")
        
        guard let array = result as? [[String: Any]] else {
            throw NSError(domain: "InvalidType", code: 0, userInfo: [NSLocalizedDescriptionKey: "Expected an array of dictionaries"])
        }
        
        return array
    }
    
    // MARK: Get

    public func getMarkdown() -> String {
        dispatchPrecondition(condition: .onQueue(.main))

        var result: String?

        self.view.content.evaluateJavaScript("api.app.getMarkdown()") { response, error in
            if error != nil {
                result = ""
                return
            }

            result = response as? String ?? ""
        }

        while result == nil {
            RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.01))
        }

        return result ?? ""
    }

    // MARK: 插入节点

    public func insertTable() async throws -> Any {
        try await run("api.event.insertTable()")
    }

    public func insertTodo() async throws -> Any {
        try await run("api.event.insertTodo()")
    }

    public func insertDraw() async throws -> Any {
        try await run("api.event.insertDraw()")
    }

    public func insertImage() async throws -> Any {
        try await run("api.event.insertImage()")
    }

    public func insertCodeBlock() async throws -> Any {
        try await run("api.event.insertCodeBlock()")
    }

    // MARK: Toggle

    public func toggleToc() async throws -> Any {
        try await run("api.node.toggleToc()")
    }

    public func toggleItalic() async throws -> Any {
        try await run("api.event.toggleItalic()")
    }

    public func toggleBanner() async throws -> Any {
        try await run("api.event.toggleBanner()")
    }

    public func toggleBold() async throws -> Any {
        try await run("api.event.toggleBold()")
    }

    public func toggleTaskList() async throws -> Any {
        try await run("api.event.toggleTaskList()")
    }

    // MARK: Hide

    public func hideEditor() async throws -> Any {
        try await run("api.feature.hideEditor()")
    }

    public func hideToolbar() async throws -> Any {
        try await run("api.feature.hideToolbar()")
    }

    // MARK: Show

    public func showEditorAndEnableEdit() async throws -> Any {
        try await run("api.feature.showEditorAndEnableEdit()")
    }

    public func showEditor() async throws -> Any {
        try await run("api.feature.showEditor()")
    }

    public func showToolbar() async throws -> Any {
        try await run("api.feature.showToolbar()")
    }

    // MARK: Enable

    public func enableEdit() async throws -> Any {
        try await run("api.feature.enableEdit()")
    }

    public func enableTable() async throws -> Any {
        try await run("api.feature.enableTable()")
    }

    public func enableDraw() async throws -> Any {
        try await run("api.feature.enableDraw()")
    }

    @discardableResult
    public func enableFloatingMenu() async throws -> Any {
        try await run("api.feature.enableFloatingMenu()")
    }
    
    public func ping() async throws -> Any {
        try await run("api.doc.ping()")
    }


    public func enableBubbleMenu() async throws -> Any {
        try await run("api.feature.enableBubbleMenu()")
    }

    // MARK: Disable

    public func disableBubbleMenu() async throws -> Any {
        try await run("api.feature.disableBubbleMenu()")
    }

    public func disableFloatingMenu() async throws -> Any {
        try await run("api.feature.disableFloatingMenu()")
    }

    public func disableContextMenu() async throws -> Any {
        try await run("api.feature.disableContextMenu()")
    }

    public func disableFlotingMenuAndBubbleMenu() async throws -> Any {
        try await run("api.feature.disableFlotingMenuAndBubbleMenu()")
    }

    public func disableEdit() async throws -> Any {
        try await run("api.feature.disableEdit()")
    }

    public func disableTable() async throws -> Any {
        try await run("api.feature.disableTable()")
    }

    public func disableDraw() async throws -> Any {
        try await run("api.feature.disableDraw()")
    }

    // MARK: Set

    public func setToolbarVisible(_ v: Bool) async throws -> Any {
        await v ? try showToolbar() : try hideToolbar()
    }

    @discardableResult
    public func setEditable(_ v: Bool) async throws -> Any {
        await v ? try enableEdit() : try disableEdit()
    }

    public func setEditorVisible(_ v: Bool) async throws -> Any {
        await v ? try showEditor() : try hideEditor()
    }

    @discardableResult
    public func setTranslateApi(_ s: String) async throws -> Any {
        try await run("api.config.setTranslateApi(`\(s)`)")
    }
    
    // MARK: SetDrawLink

    public func setDrawLink(_ link: String) async throws {
        _ = try await run("api.doc.setDrawLink('\(link)')")
    }

    // MARK: SetBaseUrl

    @discardableResult
    public func setBaseUrl(_ url: String) async throws -> Any {
        let verbose = false
        
        if verbose {
            os_log("\(self.t)setBaseUrl -> \(url)")
        }
        
        return try await run("api.request.setBaseURL('\(url)')")
    }
    
    // MARK: SetNode

    public func setNodeBase64(_ nodeBase64: String) async throws -> Any {
        let verbose = false
        
        if verbose {
            os_log("\(self.t)setNodeBase64 -> \(nodeBase64.mini())")
        }

        return try await run("api.node.setNodeBase64(`\(nodeBase64)`)")
    }

    // MARK: SetMode 

    public func setMode(_ mode: String) async throws -> Any {
        try await run("api.mode.setMode(`\(mode)`)")
    }
    
    // MARK: SetDoc

    public func setDocBase64(_ docBase64: String) async throws -> Any {
        let verbose = false
        if verbose {
            os_log("\(self.t)setDocBase64 🛜🛜🛜 -> \(docBase64.mini())")
        }

        return try await run("api.doc.setDocBase64(`\(docBase64)`)")
    }
    
    @discardableResult
    public func setHtmlByRequest(_ id: String) async throws -> Any {
        let verbose = true
        if verbose {
            os_log("\(self.t)setHtmlByRequest 🛜🛜🛜 -> \(id)")
        }
        
        return try await run("window.api.node.setHtmlByRequest(`\(id)`)")
    }

    public func setDocEmpty() async throws -> Any {
        let verbose = false
        if verbose {
            os_log("\(self.t)setDocEmpty 🛜🛜🛜")
        }

        return try await run("api.doc.setDocEmpty()")
    }
    
    public func setDocNull() async throws -> Any {
        let verbose = false
        if verbose {
            os_log("\(self.t)setDocNull 🛜🛜🛜")
        }

        return try await run("api.doc.setDocNull()")
    }

    public func setParagraph() async throws -> Any  {
        try await run("api.event.setParagraph()")
    }

    public func setHeading1() async throws -> Any  {
        try await run("api.event.setHeading1()")
    }

    public func setHeading2() async throws -> Any  {
        try await run("api.event.setHeading2()")
    }

    public func setHeading3() async throws -> Any  {
        try await run("api.event.setHeading3()")
    }

    public func setHeading4() async throws -> Any  {
        try await run("api.event.setHeading4()")
    }

    public func setHeading5() async throws -> Any  {
        try await run("api.event.setHeading5()")
    }

    public func setHeading6() async throws -> Any {
        try await run("api.event.setHeading6()")
    }

    // MARK: Other

    public func closeDraw() async throws -> Any  {
        try await run("api.app.closeDraw()")
    }

    public func runnerCallback(_ output: String) async throws -> Any  {
        // 对字符串进行 URL 编码
        if let encodedOutput = output.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            // 调用 JavaScript 函数，并传递编码后的字符串
            try await run("runnerCallback(`\(encodedOutput)`)")
        } else {
            try await run("runnerCallback(`swift 编码失败`)")
        }
    }
}
