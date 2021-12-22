// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWCountdownButton",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "WWCountdownButton", targets: ["WWCountdownButton"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "WWCountdownButton", dependencies: []),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
