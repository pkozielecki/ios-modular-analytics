// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Storage",
        platforms: [
            .iOS(.v16),
        ],
    products: [
        .library(
            name: "Storage",
            targets: ["StorageInterfaces", "StorageImplementation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4"),
    ],
    targets: [
        .target(
            name: "StorageInterfaces",
            dependencies: []),
        .target(
            name: "StorageImplementation",
            dependencies: ["StorageInterfaces"]),
    ]
)
