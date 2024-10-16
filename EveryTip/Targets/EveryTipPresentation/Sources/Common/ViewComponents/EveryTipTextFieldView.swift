//
//  EveryTipTextFieldView.swift
//  EveryTipPresentation
//
//  Created by 손대홍 on 10/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import RxSwift
import SnapKit

enum EveryTipTextFieldStatus {
    case normal
    case editing
    case success
    case error
    case notEnabled
}

enum EveryTipTextFieldAction {
    case editingDidBegin
    case editingDidEnd
    case editingDidEndOnExit
    case clearButtonDidTapped
    case textChanged(text: String)
}
