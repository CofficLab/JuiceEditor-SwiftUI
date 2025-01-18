import MagicKit
import SwiftUI

extension EditorView {
    var panel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                MagicButton(
                    title: "清空内容",
                    action: {
                        Task {
                            try? await self.setContent("")
                        }
                    }
                )
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

                MagicButton(
                    title: "日志界面",
                    action: { self.logViewVisible.toggle()
                    }
                )

                MagicButton(
                    title: "设置内容",
                    action: {
                        Task {
                            do {
                                try await self.setContent("Current time is \(Date.now)")
                            } catch {
                                errorLog("Error setting content: \(error)")
                            }
                        }
                    }
                )

                MagicButton(
                    icon: .iconTable,
                    action: {
                        Task {
                            try? await insertTable()
                        }
                    })
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
