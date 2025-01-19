// MARK: - Editor UI Control

public extension Editor {
    func hideEditor() async throws {
        try await run("window.editor.hideEditor()")
    }
    
    func showEditor() async throws {
        try await run("window.editor.showEditor()")
    }
    
    func hideToolbar() async throws {
        try await run("window.editor.hideToolbar()")
    }
    
    func showToolbar() async throws {
        try await run("window.editor.showToolbar()")
    }
}

// MARK: - Editor Features

public extension Editor {
    func disableBubbleMenu() async throws {
        try await run("window.editor.disableBubbleMenu()")
    }
    
    func disableContextMenu() async throws {
        try await run("window.editor.disableContextMenu()")
    }
    
    func disableFloatingMenu() async throws {
        try await run("window.editor.disableFloatingMenu()")
    }
    
    func disableDebugBar() async throws {
        try await run("window.editor.disableDebugBar()")
    }
    
    func enableBubbleMenu() async throws {
        try await run("window.editor.enableBubbleMenu()")
    }
    
    func enableFloatingMenu() async throws {
        try await run("window.editor.enableFloatingMenu()")
    }
}

// MARK: - Editor Content

public extension Editor {
    func insertTable() async throws {
        try await run("window.editor.insertTable()")
    }
    
    func insertTodo() async throws {
        try await run("window.editor.insertTodo()")
    }
    
    func insertDraw() async throws {
        try await run("window.editor.insertDraw()")
    }
    
    func insertImage() async throws {
        try await run("window.editor.insertImage()")
    }
    
    func insertCodeBlock() async throws {
        try await run("window.editor.insertCodeBlock()")
    }
}

// MARK: - Editor Formatting

public extension Editor {
    func toggleBold() async throws {
        try await run("window.editor.toggleBold()")
    }
    
    func toggleItalic() async throws {
        try await run("window.editor.toggleItalic()")
    }
    
    func toggleTaskList() async throws {
        try await run("window.editor.toggleTaskList()")
    }
    
    func toggleToc() async throws {
        try await run("window.editor.toggleToc()")
    }
} 