import UIKit

import EveryTipPresentation
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let assembler = Assembler(container: .shared)

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        assemble()
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        window?.rootViewController = viewController
        
        AppIOSTestUI.hello()
        return true
    }

    private func assemble() {
        assembler.apply(assemblies: [
            // TODO: 레이어 assembly 등 등록
        ])
    }
}
