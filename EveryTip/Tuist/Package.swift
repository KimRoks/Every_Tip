// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    // Customize the product types for specific package product
    // Default is .staticFramework
    //     productTypes: [
    //        "Alamofire": .framework,
    //     ]
)
#endif
let package = Package(
    name: "MyApp",
    dependencies: [
        .package(
            url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(from: "5.0.0")
        ),
        .package(
            url: "https://github.com/SnapKit/SnapKit.git",
            .upToNextMinor(from: "5.0.1")
        ),
        .package(
            url: "https://github.com/Swinject/Swinject.git",
            .upToNextMajor(from: "2.8.0")
        ),
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "6.0.0")
        ),
        .package(url: "https://github.com/ReactorKit/ReactorKit.git",
                 .upToNextMajor(from: "3.0.0")
        ),
    ]
)
