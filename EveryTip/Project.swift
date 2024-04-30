import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin


// MARK: - Project

private let appName = "EveryTip"

private let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "15.0", devices: [.iphone])

private enum Layer: CaseIterable {
    case core
    case domain
    case data
    case presentation
    
    var layerName: String {
        switch self {
        case .core: return "\(appName)Core"
        case .domain: return "\(appName)Domain"
        case .data: return "\(appName)Data"
        case .presentation: return "\(appName)Presentation"
        }
    }
}

func makeEveryTipFrameworkTargets(
    name: String,
    platform: Platform,
    dependencies: [TargetDependency]
) -> [Target] {
    let sourceTarget = Target(
        name: name,
        platform: platform,
        product: .framework,
        bundleId: "com.sonmoham.\(name)",
        deploymentTarget: deploymentTarget,
        infoPlist: .default,
        sources: ["Targets/\(name)/Sources/**"],
        resources: [],
        dependencies: dependencies,
        settings: .settings(
            base: .init().swiftCompilationMode(.wholemodule)
        )
    )
    let testTarget = Target(
        name: "\(name)Tests",
        platform: platform,
        product: .unitTests,
        bundleId: "com.sonmoham.\(name)Tests",
        deploymentTarget: deploymentTarget,
        infoPlist: .default,
        sources: ["Targets/\(name)/Tests/**"],
        resources: [],
        dependencies: [
            .target(name: name)
            // nimble, etc ....
        ]
    )
    return [sourceTarget, testTarget]
}

func makeEveryTipAppTarget(
    platform: Platform,
    dependencies: [TargetDependency]
) -> Target {
    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0.1",
        "CFBundleVersion": "1",
        "CFBundleDisplayName": "${APP_DISPLAY_NAME}",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIUserInterfaceStyle": "Light",
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "BASE_URL": "${BASE_URL}",
        "SHARED_CONSTANT": "${SHARED_CONSTANT}",
        "ENVIRONMENT_CONSTANT": "${ENVIRONMENT_CONSTANT}"
    ]
    return .init(
        name: appName,
        platform: platform,
        product: .app,
        bundleId: "com.sonmoham.\(appName)",
        deploymentTarget: deploymentTarget,
        infoPlist: .extendingDefault(with: infoPlist),
        sources: ["Targets/\(appName)/Sources/**"],
        resources: ["Targets/\(appName)/Resources/**"],
        dependencies: dependencies,
        settings: .settings(
            base: .init()
                .swiftCompilationMode(.wholemodule)
                .automaticCodeSigning(devTeam: "type team code here")
        )
    )
}

func makeConfiguration() -> Settings {
    Settings.settings(configurations: [
        .debug(
            name: "Debug",
            xcconfig: .relativeToRoot("Targets/\(appName)/Config/Debug.xcconfig")
        ),
        .release(
            name: "Release",
            xcconfig: .relativeToRoot("Targets/\(appName)/Config/Release.xcconfig")
        )
    ])
}

let project = Project(
    name: appName,
    organizationName: appName,
    packages: [],   // add spm packages here
    settings: makeConfiguration(),
    targets: [
        // App target
        [makeEveryTipAppTarget(
            platform: .iOS,
            dependencies: [
                .target(name: Layer.presentation.layerName),
                .target(name: Layer.data.layerName)
            ]
        )],
        // presentation layer
        makeEveryTipFrameworkTargets(
            name: Layer.presentation.layerName,
            platform: .iOS,
            dependencies: [
                .target(name: Layer.domain.layerName),
                .external(name: "SnapKit")
                // snapkit, then, etc...
            ]
        ),
        // data layer
        makeEveryTipFrameworkTargets(
            name: Layer.data.layerName,
            platform: .iOS,
            dependencies: [
                .target(name: Layer.domain.layerName)
                // alamofire or moya ...
            ]
        ),
        // domain layer
        makeEveryTipFrameworkTargets(
            name: Layer.domain.layerName,
            platform: .iOS,
            dependencies: [
                .target(name: Layer.core.layerName)
            ]
        ),
        // core layer
        makeEveryTipFrameworkTargets(
            name: Layer.core.layerName,
            platform: .iOS,
            dependencies: [
                // core dependencies, rx swift etc ...
                .external(name: "Swinject"),
                .external(name: "RxSwift"),
                .external(name: "ReactorKit")
            ]
        ),
    ].flatMap { $0 }
)
