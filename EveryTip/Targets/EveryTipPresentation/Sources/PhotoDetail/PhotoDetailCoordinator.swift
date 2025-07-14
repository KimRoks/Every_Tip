//
//  PhotoDetailCoordinator.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/14/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

protocol PhotoDetailCoordinator: Coordinator {
    func start(imageURLs: [String], startIndex: Int)
    func dismiss()
}

final class DefaultPhotoDetailCoordinator: PhotoDetailCoordinator {
    
    var parentCoordinator: (any Coordinator)?
    
    var childCoordinators: [any Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() { }
    
    func start(imageURLs: [String], startIndex: Int) {
        let photoDetailVC = PhotoDetailViewController(imageURLs: imageURLs, startIndex: startIndex)
        
        photoDetailVC.coordinator = self
        photoDetailVC.modalPresentationStyle = .fullScreen
        
        navigationController.present(photoDetailVC, animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true)
        didFinish()
    }
    
    func didFinish() {
        parentCoordinator?.remove(child: self)
    }
}
