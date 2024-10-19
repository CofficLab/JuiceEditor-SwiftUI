// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "JuiceEditorSwift",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "JuiceEditorSwift",
            targets: ["JuiceEditorSwift"]),
        .executable(
            name: "JuiceEditorTestApp",
            targets: ["JuiceEditorTestApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "JuiceEditorSwift",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ]),
        .executableTarget(
            name: "JuiceEditorTestApp",
            dependencies: ["JuiceEditorSwift"],
            path: "Sources/JuiceEditorTestApp"),
        .testTarget(
            name: "JuiceEditorSwiftTests",
            dependencies: ["JuiceEditorSwift"]),
    ]
)
