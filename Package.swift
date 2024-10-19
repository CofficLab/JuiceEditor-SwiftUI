// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "JuiceEditorSwift",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "JuiceEditorSwift",
            targets: ["JuiceEditorSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JuiceEditorSwift",
            dependencies: []),
        .testTarget(
            name: "JuiceEditorSwiftTests",
            dependencies: ["JuiceEditorSwift"]),
    ]
)
