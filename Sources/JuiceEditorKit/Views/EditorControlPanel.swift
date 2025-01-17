import SwiftUI

struct EditorControlPanel: View {
    @Binding var isEditable: Bool
    @Binding var showToolbar: Bool
    @Binding var showEditor: Bool
    @Binding var logViewVisible: Bool
    @Binding var isVerbose: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // Editor Controls
                Group {
                    ControlButton(isOn: $isEditable, label: "编辑", icon: "pencil")
                    ControlButton(isOn: $showToolbar, label: "工具栏", icon: "toolbar.fill")
                    ControlButton(isOn: $showEditor, label: "编辑器", icon: "doc.text")
                    ControlButton(isOn: $logViewVisible, label: "日志", icon: "terminal")
                    ControlButton(isOn: $isVerbose, label: "详细日志", icon: "text.bubble")
                }
                
                Divider().frame(height: 20)
                
                // Insert Controls
                Group {
                    ActionButton(label: "表格", icon: "tablecells") {}
                    ActionButton(label: "待办", icon: "checklist") {}
                    ActionButton(label: "绘图", icon: "pencil.and.ruler") {}
                    ActionButton(label: "图片", icon: "photo") {}
                    ActionButton(label: "代码", icon: "chevron.left.forwardslash.chevron.right") {}
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 44)
    }
}

// Control Button for toggleable settings
private struct ControlButton: View {
    @Binding var isOn: Bool
    let label: String
    let icon: String
    
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            Label(label, systemImage: icon)
                .labelStyle(.iconOnly)
                .padding(8)
        }
        .background(isOn ? Color.accentColor.opacity(0.2) : Color.clear)
        .cornerRadius(8)
        .foregroundColor(isOn ? .accentColor : .primary)
    }
}

// Action Button for one-time actions
private struct ActionButton: View {
    let label: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Label(label, systemImage: icon)
                .labelStyle(.iconOnly)
                .padding(8)
        }
        .cornerRadius(8)
    }
} 

#Preview {
    EditorViewPre()
} 
