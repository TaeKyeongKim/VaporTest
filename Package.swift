// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "vaporServerTest",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v12)
    ],
    products: [
        .library(
                   name: "vaporServerTest",
                   targets: ["App"]
               ),
//        .executable( // 실행 가능한 타겟 추가
//             name: "vaporServerExecutable",
//             targets: ["App"]
//         )
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.99.3"),
        // 🔵 Non-blocking, event-driven networking for Swift. Used for custom executors
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
            ]
        ),
//        .executableTarget(
//            name: "App",
//            dependencies: [
//                .product(name: "Vapor", package: "vapor"),
//                .product(name: "NIOCore", package: "swift-nio"),
//                .product(name: "NIOPosix", package: "swift-nio"),
//            ],
//            swiftSettings: swiftSettings
//        ),
        .testTarget(
            name: "AppTests",
            dependencies: [
                .target(name: "App"),
                .product(name: "XCTVapor", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
