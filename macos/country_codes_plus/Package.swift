// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "country_codes_plus",
    platforms: [
        .macOS("10.14"),
    ],
    products: [
        .library(name: "country-codes-plus", targets: ["country_codes_plus"]),
    ],
    targets: [
        .target(
            name: "country_codes_plus",
            path: "Sources/country_codes_plus"
        ),
    ]
)
