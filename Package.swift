// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "TrackupCore",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13), .macOS(.v10_10)
    ],
    products: [
        .library(name: "TrackupCore", targets: ["TrackupCore"])
    ],
    targets: [
        .target(name: "TrackupCore"),
        .testTarget(
            name: "TrackupCoreTests",
            dependencies: ["TrackupCore"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
