import SwiftUI

struct EditorControlPanel: View {
    var editorView: EditorView

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Group {
                    MagicButton(
                        title: "只读",
                        action: {
                            Task {
                                try? await self.editorView.disableEdit()
                            }
                        }
                    )
                    .magicSize(.auto)
                    .frame(width: 60)
                    
                    MagicButton(
                        title: "工具栏",
                        action: {
                            Task {
                                try? await self.editorView.toggleDebugBar()
                            }
                        }
                    )
                    .magicSize(.auto)
                    .frame(width: 60)
                    
                    MagicButton(
                        title: "日志界面",
                        action: {
                            Task {
                                editorView.setLogViewVisible(false)
                            }
                        }
                    )
                    .magicSize(.auto)
                    .frame(width: 60)
                    
                    MagicButton(
                        title: "设置内容",
                        action: {
                            Task {
                                try? await editorView.setContent(UUID().uuidString)
                            }
                        }
                    )
                    .magicSize(.auto)
                    .frame(width: 60)
            
                    MagicButton(
                        icon: .iconTimer,
                        title: "表格",
                        action: {
                        Task {
                            try? await self.editorView.insertTable()
                        }
                    })
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 44)
    }
}

#Preview {
    EditorViewPre()
}
