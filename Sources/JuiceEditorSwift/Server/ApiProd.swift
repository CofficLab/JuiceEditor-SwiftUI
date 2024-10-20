import Vapor
import Foundation

extension HTTPServer {
    public func prod(app: Application) {
        // 生产模式：提供静态文件
        app.middleware.use(FileMiddleware(publicDirectory: directoryPath + "/dist"))

        app.get { req -> Response in
            self.logger.info("\(self.t)Received request for root, redirecting to ➡️ index.html")
            return req.redirect(to: "/index.html")
        }
    }
}
