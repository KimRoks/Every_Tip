//
//  UIView+.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/19/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

extension UIView {
    public func addShadow(offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
    
    public func setRoundedCorners(radius: CGFloat, corners: CACornerMask...) {
        
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = CACornerMask(corners)
    }
    
    /// this method must call in "LayoutSubViews()"
    public func makeCircular() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
