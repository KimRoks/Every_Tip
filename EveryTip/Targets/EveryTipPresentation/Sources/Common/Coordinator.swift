//
//  Coordinator.swift
//  EveryTip
//
//  Created by 손대홍 on 1/20/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject, ToastDisplayable {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
    func didFinish()
}

public extension Coordinator {
    func append(child: Coordinator) {
        childCoordinators.append(child)
    }
    
    /**
     didFinish 시
     */
    func remove(child: Coordinator) {
        guard let targetIndex = childCoordinators.firstIndex(where: { $0 === child }) else {
            return
        }
        childCoordinators.remove(at: targetIndex)
    }
}
