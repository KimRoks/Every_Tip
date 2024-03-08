//
//  UIView+.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/19/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    static func createLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        return line
    }
}
