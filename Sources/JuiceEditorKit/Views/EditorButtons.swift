import SwiftUI
import MagicKit

// MARK: - Button Views

extension EditorContent {
    // MARK: Formatting Buttons
    
    func makeFormattingButtons() -> some View {
        HStack(spacing: 12) {
            makeButton(
                icon: "bold",
                action: editor.toggleBold
            )
            
            makeButton(
                icon: "italic",
                action: editor.toggleItalic
            )
            
            makeButton(
                icon: "list.bullet",
                action: editor.toggleTaskList
            )
            
            makeButton(
                icon: "list.number",
                action: editor.toggleToc
            )
        }
    }
    
    // MARK: Insert Buttons
    
    func makeInsertButtons() -> some View {
        HStack(spacing: 12) {
            makeButton(
                icon: "tablecells",
                action: editor.insertTable
            )
            
            makeButton(
                icon: "checkmark.square",
                action: editor.insertTodo
            )
            
            makeButton(
                icon: "pencil.and.scribble",
                action: editor.insertDraw
            )
            
            makeButton(
                icon: "photo",
                action: editor.insertImage
            )
            
            makeButton(
                icon: "chevron.left.forwardslash.chevron.right",
                action: editor.insertCodeBlock
            )
        }
    }
    
    // MARK: Control Buttons
    
    func makeControlButtons() -> some View {
        HStack(spacing: 12) {
            makeButton(
                icon: "doc.text.fill",
                action: {
                    try? await editor.setContent("")
                }
            )
            
            makeButton(
                icon: "lock.fill",
                action: {
                    try? await editor.disableEdit()
                }
            )
            
            makeButton(
                icon: "trash",
                action: { try? await editor.setContent("") }
            )
            
            makeButton(
                icon: "terminal",
                action: {
                    try? await editor.toggleDebugBar()
                }
            )
        }
    }
}

// MARK: - Helper Views

private extension EditorContent {
    func makeButton(
        icon: String,
        action: @escaping () async throws -> Void
    ) -> some View {
        Button(
            action: {
                Task {
                    try? await action()
                }
            }
        ) {
            Image(systemName: icon)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.borderless)
    }
}

// MARK: - Toolbar Layout

extension EditorContent {
    func makeToolbar() -> some View {
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
        }
    }
}

#Preview {
    EditorPreview()
}
