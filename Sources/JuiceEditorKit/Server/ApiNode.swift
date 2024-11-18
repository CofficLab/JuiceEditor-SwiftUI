import Foundation
import OSLog
import Vapor

extension HTTPServer {
    public func getNode(app: Application, verbose: Bool) {
        app.get("api", "node", ":id", "html") { req async throws -> String in
            
            guard let id = req.parameters.get("id") else {
                throw Abort(.badRequest)
            }
            
            let content = self.delegate.getHtml(id) ?? ""
            
            if verbose {
                os_log("\(self.t)getNode(\(id)): \(content.max(120))")
            }

            return content
        }
    }
}
