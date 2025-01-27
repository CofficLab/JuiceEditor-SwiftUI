import Vapor
import Foundation
import OSLog

extension HTTPServer {
    public func prod(app: Application) {
        let publicDirectory = directoryPath + "dist/"
        
        app.middleware.use(FileMiddleware(publicDirectory: publicDirectory))
        
        // 添加根路径路由
        app.get { req -> Response in
            return req.fileio.streamFile(at: publicDirectory + "index.html")
        }
    }
}
