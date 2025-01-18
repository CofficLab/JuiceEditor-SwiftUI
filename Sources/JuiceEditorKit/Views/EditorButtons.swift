import Foundation
import SwiftUI

public extension EditorView {
    // MARK: Views
    
    func getLogView() -> some View {
        Logger.logView()
    }

    func makeToolbar() -> some View {
        HStack {
            makeSetContentButton()
            makeReadOnlyButton()
            makeClearContentButton()
            makeLogButton()
            makeTableButton()
        }.padding(.top)
    }
    
    // MARK: Buttons

    func makeTableButton() -> some View {
        MagicButton(
            icon: .iconTable,
            action: {
                Task {
                    try? await self.insertTable()
                }
            }).magicStyle(.secondary).magicShape(.circle)
    }

    func makeLogButton() -> some View {
        Logger.logButton()
    }

    func makeDebugBarButton() -> some View {
        MagicButton(
            icon: .iconTopToolbar,
            action: {
                Task {
                    try? await self.toggleDebugBar()
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }

    func makeClearContentButton() -> some View {
        MagicButton(
            icon: .iconTrash,
            action: {
                Task {
                    try? await self.setContent("")
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }

    func makeReadOnlyButton() -> some View {
        MagicButton(
            icon: .iconReadOnly,
            action: {
                Task {
                    try? await self.disableEdit()
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }

    func makeSetContentButton() -> some View {
        MagicButton(
            icon: .iconDocumentFill,
            action: {
                Task {
                    do {
                        try await self.setContent("Current time is \(Date.now)")
                    } catch {
                        errorLog("Error setting content: \(error)")
                    }
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }
}

#Preview {
    EditorDemo()
}
