// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SampleFeature",
        platforms: [
            .iOS(.v16),
        ],
    products: [
        .library(
            name: "SampleFeature",
            targets: ["SampleFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
        .package(path: "../Analytics"),
        .package(path: "../Dependencies"),
        .package(path: "../Storage"),
    ],
    targets: [
        .target(
            name: "SampleFeature",
            dependencies: [
                "Analytics",
                "Dependencies",
                "Storage",
            ]),
        .testTarget(
            name: "SampleFeatureTests",
            dependencies: ["SampleFeature"]),
    ]
)
