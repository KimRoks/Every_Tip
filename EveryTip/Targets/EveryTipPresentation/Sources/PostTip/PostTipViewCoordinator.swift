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
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    var postTipViewController: PostTipViewController?
    var presentingViewController: UIViewController?
    
    init(navigationController: UINavigationController,
         presentingViewController: UIViewController) {
        self.navigationController = navigationController
        self.presentingViewController = presentingViewController
    }
    
    func start() {
        postTipViewController = PostTipViewController()
        postTipViewController?.coordinator = self
        presentPostView()
    }
    
    func presentPostView() {
        guard let postTipViewController = postTipViewController else {
            return
        }
        postTipViewController.modalPresentationStyle = .fullScreen
        guard let presentingViewController = presentingViewController else {
            return
        }
        presentingViewController.present(
            postTipViewController,
            animated: true,
            completion: nil
        )
    }
    
    func dismissPostView() {
        guard let presentingViewController = presentingViewController else {
            return
        }
        presentingViewController.dismiss(animated: true)
    }
    
    func didFinish() {
        dismissPostView()
    }
}
