import Foundation
import SwiftUI

public struct EditorApp {
    private let editorView: EditorView

    init() {
        self.editorView = EditorView()
    }
    
    // MARK: Views

    func getEditorView() -> EditorView {
        editorView
    }
    
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

    func makeTableButton() -> MagicButton {
        MagicButton(
            icon: .iconTable,
            action: {
                Task {
                    try? await self.editorView.insertTable()
                }
            }).magicStyle(.secondary).magicShape(.circle)
    }

    func makeLogButton() -> MagicButton {
        Logger.logButton()
    }

    func makeDebugBarButton() -> MagicButton {
        MagicButton(
            icon: .iconTopToolbar,
            action: {
                Task {
                    try? await self.editorView.toggleDebugBar()
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }

    func makeClearContentButton() -> MagicButton {
        MagicButton(
            icon: .iconTrash,
            action: {
                Task {
                    try? await self.editorView.setContent("")
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }

    func makeReadOnlyButton() -> MagicButton {
        MagicButton(
            icon: .iconReadOnly,
            action: {
                Task {
                    try? await self.editorView.disableEdit()
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }

    func makeSetContentButton() -> MagicButton {
        MagicButton(
            icon: .iconDocumentFill,
            action: {
                Task {
                    do {
                        try await self.editorView.setContent("Current time is \(Date.now)")
                    } catch {
                        errorLog("Error setting content: \(error)")
                    }
                }
            }
        ).magicStyle(.secondary).magicShape(.circle)
    }
}

#Preview {
    EditorAppPre()
}
