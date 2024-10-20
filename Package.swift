// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "JuiceEditorSwift",
    platforms: [
        .macOS(.v14)
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
        .package(url: "https://github.com/CofficLab/MagicKit.git", branch: "main")
    ],
    targets: [
        .target(
            name: "JuiceEditorSwift",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "MagicKit", package: "MagicKit")
            ],
            resources: [
                .copy("./WebApp")
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
