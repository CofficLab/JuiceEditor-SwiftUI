import Foundation
import SwiftUI

public protocol EditorDelegate: AnyObject {
    /// 获取指定 UUID 的 HTML 内容
    func getHtml(_ uuid: String) async throws -> String?
    
    /// 编辑器准备就绪的回调
    func onReady()
    
    /// 节点更新的回调
    func onUpdateNodes(_ nodes: [EditorNode])
    
    /// 聊天功能的回调
    func chat(_ text: String, callback: @escaping (String) async throws -> Void) async throws
}

// MARK: - Default Implementation

public extension EditorDelegate {
    func onReady() {}
    func onUpdateNodes(_ nodes: [EditorNode]) {}
    func chat(_ text: String, callback: @escaping (String) async throws -> Void) async throws {}
}

// MARK: - Default Delegate

public final class DefaultDelegate: EditorDelegate {
    public init() {}
    
    public func getHtml(_ uuid: String) async throws -> String? {
        return "# Welcome to Editor\n\nStart editing..."
    }
}

#Preview {
    EditorPreview()
        .frame(height: 800)
}
