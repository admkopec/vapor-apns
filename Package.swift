// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "VaporAPNS",
    products: [
        .library(name: "VaporAPNS", targets: ["VaporAPNS"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/service.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/console.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0"),
        .package(url: "https://github.com/toto/CCurl.git", from: "0.4.0")
    ],
    targets: [
        .target(name: "VaporAPNS", dependencies: ["CCurl", "Console", "Service", "JWT"]),
        .testTarget(name: "VaporAPNSTests", dependencies: ["VaporAPNS"])
    ]
)
