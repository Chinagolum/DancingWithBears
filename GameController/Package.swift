// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "GameController",
    platforms: [
        .iOS(.v15),// Specify the minimum iOS version
        .macOS(.v12) // Add macOS for preview purposes

    ],
    products: [
        // This library exposes your GameController component to other packages/apps
        .library(
            name: "GameController",
            targets: ["GameController"]
        ),
    ],
    dependencies: [
        // No external dependencies for now
    ],
    targets: [
        // The main target containing your GameController SwiftUI code
        .target(
            name: "GameController",
            dependencies: [],
            path: "Sources" // Make sure your GameController.swift file is inside Sources/
        ),
        
        // Optional test target
        .testTarget(
            name: "GameControllerTests",
            dependencies: ["GameController"],
            path: "Tests"
        ),
    ]
)
