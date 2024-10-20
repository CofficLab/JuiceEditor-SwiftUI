import Foundation
import OSLog
import MagicKit

public struct DefaultDelegate: EditorDelegate, SuperLog {
    let emoji = "👮"
    
    public func getHtml(_ uuid: String) -> String? {
        os_log("\(t)Get Node")
        
        return "Hi from DefaultDelegate"
    }
    
    public func onReady() {
        os_log("\(t)Editor Ready")
    }
}
