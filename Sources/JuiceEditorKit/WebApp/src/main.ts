import './style.css'
import editor from '@coffic/juice-editor'

declare global {
    interface Window {
        editor: typeof editor;
    }
}

window.editor = editor
