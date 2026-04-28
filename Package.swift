// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "TypographyPrimitive",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "TypographyPrimitive", targets: ["TypographyPrimitive"]),
    ],
    targets: [
        .target(name: "TypographyPrimitive"),
        .testTarget(
            name: "TypographyPrimitiveTests",
            dependencies: ["TypographyPrimitive"]
        ),
    ]
)
