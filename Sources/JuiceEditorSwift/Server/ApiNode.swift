import Foundation
import OSLog
import Vapor

extension HTTPServer {
    public func getNode(app: Application) {
        app.get("api", "node", ":id", "html") { req async throws -> String in
            guard let id = req.parameters.get("id") else {
                throw Abort(.badRequest)
            }

            return self.delegate.getHtml(id) ?? ""
        }
    }
}
