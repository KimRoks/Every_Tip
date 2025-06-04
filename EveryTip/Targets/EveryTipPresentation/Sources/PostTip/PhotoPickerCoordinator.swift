//
//  PhotoPickerCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/4/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

protocol PhotoPickerCoordinator: Coordinator {
    
}

final class DefaultPhotoPickerCoordinator: PhotoPickerCoordinator {
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    var presenstingViewController: UIViewController?
    
    init(navigationController: UINavigationController,
         presentingViewController: UIViewController) {
        self.navigationController = navigationController
        self.presenstingViewController = presentingViewController
    }
    
    func start() {
        let photoPickerViewContoller = PhotoPickerViewController()
        photoPickerViewContoller.coordinator = self
        presenstingViewController?.present(
            photoPickerViewContoller,
            animated: true
        )
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
