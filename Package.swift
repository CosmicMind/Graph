// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "Graph",
    platforms: [
        .iOS("12.0"),
      .macOS("10.14")
    ],
    products: [
        .library(
            name: "Graph",
            targets: ["Graph"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "Graph",
            path: "Sources"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
