import Vapor

extension HTTPServer {
    public func dev(app: Application) {
        // 明确定义根路径路由
        app.get { req -> ClientResponse in
            self.logger.info("Processing root request in dev mode")
            return try await self.handleDevModeRequest(req, path: "/index.html")
        }

        // 定义通配符路由
        app.get("**") { req -> ClientResponse in
            self.logger.info("Processing wildcard request in dev mode: \(req.url.string)")
            return try await self.handleDevModeRequest(req, path: req.url.path)
        }
    }
    
    

    // 添加一个辅助方法来处理开发模式的请求
    public func handleDevModeRequest(_ req: Request, path: String) async throws -> ClientResponse {
        let client = req.client
        var url = self.vueDevServerURL + path
        if let query = req.url.query {
            url += "?" + query
        }
        if let fragment = req.url.fragment {
            url += "#" + fragment
        }
        self.logger.info("Forwarding to: \(url)")
        return try await client.get(URI(string: url))
    }
}
