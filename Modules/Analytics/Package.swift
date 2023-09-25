// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
        name: "Analytics",
        platforms: [
            .iOS(.v16),
        ],
        products: [
            .library(
                    name: "Analytics",
                    targets: [
                        "AnalyticsInterfaces",
                        "AnalyticsImplementation",
                        "AnalyticsFirebaseClient"
                    ]
            ),
        ],
        dependencies: [
            .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "10.4.0")),
        ],
        targets: [
            .target(
                    name: "AnalyticsInterfaces",
                    dependencies: [
                    ]
            ),
            .target(
                    name: "AnalyticsImplementation",
                    dependencies: [
                        "AnalyticsInterfaces"
                    ]
            ),
            .target(
                    name: "AnalyticsFirebaseClient",
                    dependencies: [
                        .product(name: "FirebaseAnalyticsSwift", package: "firebase-ios-sdk"),
                        "AnalyticsInterfaces"
                    ]
            ),
            .testTarget(
                    name: "AnalyticsImplementationTests",
                    dependencies: [
                        "AnalyticsInterfaces",
                        "AnalyticsImplementation"
                    ]
            ),
            .testTarget(
                    name: "AnalyticsFirebaseClientTests",
                    dependencies: [
                        "AnalyticsInterfaces",
                        "AnalyticsFirebaseClient"
                    ]
            )
        ]
)
