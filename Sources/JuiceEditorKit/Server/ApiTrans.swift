import Foundation
import Vapor

public extension HTTPServer {
    func translate(app: Application) {
        app.post("api", "translate") { req async throws -> String in
            struct TranslateRequest: Content {
                let lang: String
                let text: String
            }

            let req = try req.content.decode(TranslateRequest.self)

            return await self.delegate.translate(req.text, language: req.lang)
        }
    }
}
