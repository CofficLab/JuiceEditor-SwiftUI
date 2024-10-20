import Foundation
import Vapor

public extension HTTPServer {
    func translate(app: Application) {
        app.post("api", "translate") { req async throws -> String in
            let verbose = true

            struct TranslateRequest: Content {
                let lang: String
                let text: String
            }

            return "eeee"
        }
    }
}
