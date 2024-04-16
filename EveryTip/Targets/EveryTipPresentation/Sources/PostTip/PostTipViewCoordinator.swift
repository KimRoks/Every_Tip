//
//  PostTipViewCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/7/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

protocol PostTipViewCoordinator: Coordinator { }

final class DefaultPostTipViewCoordinator: PostTipViewCoordinator {
    weak var parentCoordinator: Coordinator?
    let postTipViewController = PostTipViewController()
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        postTipViewController.coordinator = self
        presentPostView()
    }
    
    func presentPostView() {
        postTipViewController.modalPresentationStyle = .fullScreen
        navigationController.present(
            postTipViewController,
            animated: true,
            completion: nil
        )
    }
    
    func dismissPostView() {
        navigationController.dismiss(animated: true)
    }
    
    func didFinish() { }
}
