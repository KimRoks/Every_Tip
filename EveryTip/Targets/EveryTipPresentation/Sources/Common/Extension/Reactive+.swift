//
//  Reactive+.swift
//  EveryTipPresentation
//
//  Created by 손대홍 on 10/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let event = sentMessage(#selector(UIViewController.viewDidLoad)).map { _ in }
        return ControlEvent(events: event)
    }
    
    var viewWillAppear: ControlEvent<Void> {
        let event = sentMessage(#selector(UIViewController.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: event)
    }
}

