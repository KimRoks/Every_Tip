//
//  UIKitExtension++.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/14/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

extension UIView {
    func configureShadow(offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

extension UIColor {
    //색상 코드: #43AC75
    static let signatureGreen = UIColor(red: 0.26, green: 0.67, blue: 0.46, alpha: 1.00)
    //색상 코드: #5ACC90
    static let signatureLightGreen = UIColor(red: 0.35, green: 0.80, blue: 0.56, alpha: 1.00)
}
