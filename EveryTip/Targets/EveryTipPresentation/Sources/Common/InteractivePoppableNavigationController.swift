//
//  InteractivePoppableNavigationController.swift
//  EveryTip
//
//  Created by 손대홍 on 1/20/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public final class InteractivePoppableNavigationController: UINavigationController {
    public init() {
        super.init(nibName: nil, bundle: nil)
        
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override init(rootViewController: UIViewController) {
         super.init(rootViewController: rootViewController)
         
         interactivePopGestureRecognizer?.delegate = self
     }
     
     @available(*, unavailable)
     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

extension InteractivePoppableNavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        // count > 1일 경우 other gesture 들은 무시된다.
        return viewControllers.count > 1
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // count > 1일 경우에만 gesture begin
        return viewControllers.count > 1
    }
}
