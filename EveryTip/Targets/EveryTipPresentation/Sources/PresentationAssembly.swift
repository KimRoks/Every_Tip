//
//  PresentationAssembly.swift
//  EveryTip
//
//  Created by 손대홍 on 1/21/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import Swinject

public struct PresentationAssembly: Assembly {
    private let navigationController: UINavigationController
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func assemble(container: Container) {
        container.register(MainTabCoordinator.self) { _ in
            DefaultMainTabCoordinator(navigationController: navigationController)
        }
    }
}
