import SwiftUI

extension EditorView {
    var panel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                Group {
                    MagicButton(
                        title: "只读",
                        action: {
                            Task {
                                try? await self.disableEdit()
                            }
                        }
                    )                    
                    MagicButton(
                        title: "工具栏",
                        action: {
                            Task {
                                try? await self.toggleDebugBar()
                            }
                        }
                    )
                    .magicSize(.auto)
                    .frame(width: 60)
                    
                    MagicButton(
                        title: "日志界面",
                        action: {
                            Task {
                                setLogViewVisible(false)
                            }
                        }
                    )
                    
                    MagicButton(
                        title: "设置内容",
                        action: {
                            Task {
                                try? await setContent(UUID().uuidString)
                            }
                        }
                    )
            
                    MagicButton(
                        icon: .iconTimer,
                        title: "表格",
                        action: {
                        Task {
                            try? await insertTable()
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
    EditorView()
        .frame(height: 800)
}
