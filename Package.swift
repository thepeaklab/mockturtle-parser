// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MockturtleParser",
    products: [
        .library(name: "MockturtleParser", targets: ["MockturtleParser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams", from: "1.0.1"),
    ],
    targets: [
        .target(name: "MockturtleParser", dependencies: ["Yams"]),
        .testTarget(name: "MockturtleParserTests", dependencies: ["MockturtleParser"]),
    ]
)
