// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "swift-perception",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(name: "Perception", targets: ["Perception"])
  ],
  dependencies: [
    .package(url: "https://github.com/sjavora/swift-syntax-xcframeworks.git", from: "509.0.2"),
    .package(path: "../swift-macro-testing"),
    .package(url: "https://github.com/pointfreeco/xctest-dynamic-overlay", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "Perception",
      dependencies: [
        "PerceptionMacros",
        .product(name: "XCTestDynamicOverlay", package: "xctest-dynamic-overlay"),
      ]
    ),
    .testTarget(
      name: "PerceptionTests",
      dependencies: ["Perception"]
    ),

    .macro(
      name: "PerceptionMacros",
      dependencies: [
        .product(name: "SwiftSyntaxWrapper", package: "swift-syntax-xcframeworks")
      ]
    ),
    .testTarget(
      name: "PerceptionMacrosTests",
      dependencies: [
        "PerceptionMacros",
        .product(name: "MacroTesting", package: "swift-macro-testing"),
      ]
    ),
  ]
)

for target in package.targets where target.type != .system {
  target.swiftSettings = target.swiftSettings ?? []
  target.swiftSettings?.append(contentsOf: [
    .enableExperimentalFeature("StrictConcurrency"),
  ])
}
