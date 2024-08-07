// swift-tools-version: 5.9

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
            name: "Later",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency"),
                .unsafeFlags(["-warnings-as-errors"])
            ]
        ),
        .testTarget(
            name: "LaterTests",
            dependencies: ["Later"]
        )
    ]
)
