import SwiftUI
import MagicKit

struct EditorToolbar: View {
    @ObservedObject var editor: Editor
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 20) {
                makeFormattingButtons()
                Divider()
                makeInsertButtons()
                Divider()
                makeControlButtons()
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
        }.frame(height: 50)
    }
    
    // MARK: - Formatting Buttons
    
    private func makeFormattingButtons() -> some View {
        HStack(spacing: 12) {
            makeButton(icon: "bold", title: "粗体") {
                try await editor.toggleBold()
            }
            
            makeButton(icon: "italic", title: "斜体") {
                try await editor.toggleItalic()
            }
            
            makeButton(icon: "list.bullet", title: "任务列表") {
                try await editor.toggleTaskList()
            }
            
            makeButton(icon: "list.number", title: "目录") {
                try await editor.toggleToc()
            }
        }
    }
    
    // MARK: - Insert Buttons
    
    private func makeInsertButtons() -> some View {
        HStack(spacing: 12) {
            makeButton(icon: "tablecells", title: "插入表格") {
                try await editor.insertTable()
            }
            
            makeButton(icon: "checkmark.square", title: "插入待办") {
                try await editor.insertTodo()
            }
            
            makeButton(icon: "pencil.and.scribble", title: "插入绘图") {
                try await editor.insertDraw()
            }
            
            makeButton(icon: "photo", title: "插入图片") {
                try await editor.insertImage()
            }
            
            makeButton(icon: "chevron.left.forwardslash.chevron.right", title: "插入代码") {
                try await editor.insertCodeBlock()
            }
        }
    }
    
    // MARK: - Control Buttons
    
    private func makeControlButtons() -> some View {
        HStack(spacing: 12) {
            makeButton(icon: "doc.text.fill", title: "清空内容", style: .secondary) {
                try await editor.setContent("")
            }
            
            makeButton(icon: "lock.fill", title: "只读模式", style: .secondary) {
                try await editor.disableEdit()
            }
            
            makeButton(icon: "terminal", title: "调试工具", style: .secondary) {
                try await editor.toggleDebugBar()
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func makeButton(
        icon: String,
        title: String,
        style: MagicButton.Style = .primary,
        action: @escaping () async throws -> Void
    ) -> some View {
        MagicButton(
            icon: icon,
            title: title,
            style: style,
            size: .small,
            shape: .roundedRectangle,
            shapeVisibility: .onHover
        ) {
            Task {
                do {
                    try await action()
                } catch {
                    print("Button action failed: \(error)")
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    EditorPreview()
}
