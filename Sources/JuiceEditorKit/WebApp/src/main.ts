import './style.css'
import { Editor, EditorFactory } from '@coffic/juice-editor'

declare global {
    interface Window {
        editor: Editor;
    }
}

EditorFactory.register('juice-editor', {
    onCreate: (editor) => {
        window.editor = editor
        editor.enableLog()
        editor.enableWebKit()
    }
})
