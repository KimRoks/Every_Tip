import EveryTipPresentation
import EveryTipData
import EveryTipDomain

import UIKit

import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let assembler = Assembler(container: .shared)
    private var navigationController : UINavigationController?
    private var mainCoordinator: MainCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let navigationController = InteractivePoppableNavigationController()
        self.navigationController = navigationController
        window?.rootViewController = navigationController
        
        assemble(navigationController: navigationController)
        
        self.mainCoordinator = DefaultMainCoordinator(navigationController: navigationController)
        mainCoordinator?.start()
        return true
    }

    private func assemble(navigationController: UINavigationController) {
        assembler.apply(assemblies: [
            DataAssembly(),
            DomainAssembly(),
            PresentationAssembly(navigationController: navigationController)
        ])
    }
}
