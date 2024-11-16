// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Later",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .tvOS(.v16),
        .watchOS(.v9),
        .macCatalyst(.v16),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "Later",
            targets: ["Later"]
        )
    ],
    targets: [
        .target(
            name: "Later"
        ),
        .testTarget(
            name: "LaterTests",
            dependencies: ["Later"]
        )
    ]
)
