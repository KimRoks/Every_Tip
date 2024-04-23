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
    
    //MARK: Internal Properties
    
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    //MARK: Private Properties
    
    private var postTipViewController: PostTipViewController?
    private weak var presentingViewController: UIViewController?
    
    init(navigationController: UINavigationController,
         presentingViewController: UIViewController) {
        self.navigationController = navigationController
        self.presentingViewController = presentingViewController
    }
    
    //MARK: Internal Methods
    
    func start() {
        postTipViewController = PostTipViewController()
        postTipViewController?.coordinator = self
        presentPostView()
    }
    
    func didFinish() {
        guard let presentingViewController = presentingViewController else {
            return
        }
        presentingViewController.dismiss(
            animated: true,
            completion: removeSelfFromParentCoordinator
        )
    }
    
    //MARK: Private Methods
    
    private func removeSelfFromParentCoordinator() {
        parentCoordinator?.remove(child: self)
    }
    
    private func presentPostView() {
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
}
