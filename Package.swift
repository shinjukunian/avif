// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "avif",
    platforms: [.macOS(.v10_13), .iOS(.v12)],
    
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "avif",
            targets: ["avif"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "avif",
            dependencies: ["Clibavif_shim"]),
        
//        .binaryTarget(name: "Clibavif",
//                      path: "Sources/Clibavif/Clibavif.xcframework"),
        
        .binaryTarget(name: "Clibavif",
                      url: "https://dl.bintray.com/shinjukunian/Clibavif/Clibavif.xcframework.zip",
                      checksum: "7577d83bb4b6873fe4661c62a5cfb2ecdba3810e7f5b70755d5e7ffeea8eeb08"),
        
        //this is a bit of an awkward workaround to build a swift module - one could try to include a modulemap in the .xcframework but it is not entirely clear where that would go in the framework structure. 
        .target(name: "Clibavif_shim", dependencies: ["Clibavif"], path: nil, exclude: [String](), sources: nil, resources: nil, publicHeadersPath: nil, cSettings: nil, cxxSettings: nil, swiftSettings: nil, linkerSettings: nil),
        
        .testTarget(
            name: "avifTests",
            dependencies: ["avif"]),
    ]
)
