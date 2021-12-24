// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ABNetworking",
    platforms: [.iOS(.v13),
                .macOS(.v10_15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ABNetworking",
            targets: ["ABNetworking"]),
    ],
    dependencies: [.package(url: "https://github.com/JanGorman/Hippolyte.git",
                            .exact("1.4.0"))],
    targets: [
        .target(
            name: "ABNetworking",
            dependencies: []),
        .testTarget(
            name: "ABNetworkingTests",
            dependencies: ["ABNetworking", "Hippolyte"]),
    ]
)
