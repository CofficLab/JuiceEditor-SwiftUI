# JuiceEditorKit

This Swift package provides a view that displays a rich text editor.

The rich text editor implementation comes from [JuiceEditor](https://github.com/CofficLab/JuiceEditor).

![image](./docs/hero.png)

## Features

- Integrates rich text editing functionality provided by JuiceEditor.
- Supports various text formats and styles.
- Easy to use and customize in Swift projects.

## Installation

1. Open your Xcode project.
2. Select `File` > `Swift Packages` > `Add Package Dependency`.
3. Enter the repository URL: `https://github.com/CofficLab/JuiceEditorSwift`.
4. Choose the latest version and add it to your project.

## Usage

Import the package and use it in your SwiftUI view:

```swift
import SwiftUI
import JuiceEditorKit

struct ContentView: View {
    var body: some View {
        EditorView()
    }
}
```

## Related Projects

- [JuiceEditor](https://github.com/CofficLab/JuiceEditor)
- [JuiceEditor-Draw](https://github.com/CofficLab/JuiceEditor-Draw)
- [JuiceEditor-Playground](https://github.com/cofficlab/JuiceEditor-Playground)
- [JuiceEditor-Examples](https://github.com/cofficlab/JuiceEditor-Examples)
