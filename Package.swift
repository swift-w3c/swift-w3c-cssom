// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-w3c-cssom",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "W3C CSSOM",
            targets: ["W3C CSSOM"]
        )
    ],
    targets: [
        .target(
            name: "W3C CSSOM",
            dependencies: []
        ),
        .testTarget(
            name: "W3C CSSOM Tests",
            dependencies: [
                "W3C CSSOM"
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
