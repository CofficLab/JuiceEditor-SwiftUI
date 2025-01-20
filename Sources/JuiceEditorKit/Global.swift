import MagicKit
import OSLog

typealias Logger = MagicLogger
typealias MagicCard = MagicKit.MagicCard
typealias MagicApp = MagicKit.MagicApp
typealias MagicLoading = MagicKit.MagicLoading
typealias MagicButton = MagicKit.MagicButton

// 创建便捷的日志函数
func info(_ message: String, caller: String = #fileID) {
    Logger.info(message, caller: caller)
}

func debug(_ message: String, caller: String = #fileID, line: Int = #line) {
    Logger.debug(message, caller: caller, line: line)
}

func warning(_ message: String, caller: String = #fileID) {
    Logger.warning(message, caller: caller)
}

func errorLog(_ message: String, caller: String = #fileID) {
    Logger.error(message, caller: caller)
}
