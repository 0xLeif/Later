// swift-tools-version: 5.10

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
    dependencies: [
        // Used for GitHub CI
        .package(url: "https://github.com/swiftlang/swift-testing.git", exact: "0.8.0")
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
            dependencies: [
                "Later",
                // Used for GitHub CI
                .product(name: "Testing", package: "swift-testing")
            ]
        )
    ]
)
