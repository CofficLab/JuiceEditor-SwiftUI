import Foundation
import SwiftUI
import Vapor

extension HTTPServer {
    public func getNode(app: Application) {
        app.get("api", "node", ":id", "html") { req async throws -> String in

            guard let id = req.parameters.get("id") else {
                throw Abort(.badRequest)
            }

            let content = try await self.delegate.getHtml(id) ?? ""

            debug("getNode(\(id)): \(content.max(120))")

            return content
        }
    }
}

#Preview {
    EditorPreview()
        .frame(height: 1000)
        .frame(width: 700)
}
