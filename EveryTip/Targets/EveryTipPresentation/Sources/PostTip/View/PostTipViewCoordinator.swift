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
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    var postTipViewController: PostTipViewController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        postTipViewController = PostTipViewController()
    }
    
    func start() {
        startPostView()
    }
    
    private func startPostView() {
        postTipViewController.modalPresentationStyle = .fullScreen
        navigationController.present(postTipViewController, animated: true, completion: nil)
    }
    
    func didFinish() { }
}
