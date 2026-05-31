// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "country_codes_plus",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "country-codes-plus", targets: ["country_codes_plus"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        .target(
            name: "country_codes_plus",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            path: "Sources/country_codes_plus"
        ),
    ]
)
