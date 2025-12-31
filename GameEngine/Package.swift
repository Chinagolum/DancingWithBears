// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "GameEngine",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GameEngine",
            targets: ["GameEngine"]
        ),
    ],
    targets: [
        .target(
            name: "GameEngine",
            path: "Sources/GameEngine",
            resources: [
                .process("art.scnassets") // relative to target folder
            ]
        ),
        .testTarget(
            name: "GameEngineTests",
            dependencies: ["GameEngine"]
        ),
    ]
)
