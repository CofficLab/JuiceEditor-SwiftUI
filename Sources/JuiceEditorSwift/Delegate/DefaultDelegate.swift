import Foundation
import OSLog
import MagicKit

public struct DefaultDelegate: EditorDelegate, SuperLog {
    let emoji = "👮"
    
    public func getNode() {
        os_log("\(t)Get Node")
    }
    
    public func onReady() {
        os_log("\(t)Editor Ready")
    }
}
