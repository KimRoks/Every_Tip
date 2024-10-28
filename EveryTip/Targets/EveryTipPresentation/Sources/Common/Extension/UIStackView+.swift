//
//  UIStackView+.swift
//  EveryTipPresentation
//
//  Created by 손대홍 on 10/16/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

extension UIStackView {
    @discardableResult
    func addArrangedSubViews(_ subviews: UIView...) -> UIStackView {
        subviews.forEach { addArrangedSubview($0) }
        return self
    }
}
