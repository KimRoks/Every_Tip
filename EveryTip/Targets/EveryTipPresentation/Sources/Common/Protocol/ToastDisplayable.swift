//
//  ToastDisplayable.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public protocol ToastDisplayable {
    func show(message: String)
}

public extension ToastDisplayable {
    func show(message: String) {
        ToastManager.shared.show(message: message)
    }
}
