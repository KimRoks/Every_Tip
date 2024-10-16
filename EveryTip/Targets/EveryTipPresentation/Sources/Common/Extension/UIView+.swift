//
//  UIView+.swift
//  EveryTipPresentation
//
//  Created by 손대홍 on 10/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func addSubViews(_ subviews: UIView...) -> UIView {
        subviews.forEach { addSubview($0) }
        return self
    }
}
