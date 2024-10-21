# Swift Package: Rich Text Editor View

这个 Swift 包提供了一个视图，其中展示了一个富文本编辑器。

富文本编辑器的实现来自于 [JuiceEditor](https://github.com/CofficLab/JuiceEditor)。

## 特性

- 集成了 JuiceEditor 提供的富文本编辑功能。
- 支持多种文本格式和样式。
- 易于在 Swift 项目中使用和定制。

## 安装

1. 打开你的 Xcode 项目。
2. 选择 `File` > `Swift Packages` > `Add Package Dependency`。
3. 输入仓库的 URL: `https://github.com/CofficLab/JuiceEditorSwift`。
4. 选择最新的版本并添加到你的项目中。

## 使用

在你的 SwiftUI 视图中导入包并使用：

```swift
import JuiceEditorSwift

struct ContentView: View {
    var body: some View {
        EditorView()
    }
}
```
