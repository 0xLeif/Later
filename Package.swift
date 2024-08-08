// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Later",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macCatalyst(.v13),
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
