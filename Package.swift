// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "mogif",
    products: [
      .executable(name: "mogif", targets: ["mogif"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pdesantis/CommandLine", .branch("swift4")),
    ],
    targets: [
      .target(name: "mogif",
              dependencies: ["CommandLine"],
              path: "Sources")
    ],
    swiftLanguageVersions: [4]
)
