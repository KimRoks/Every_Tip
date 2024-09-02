//
//  UIFont+.swift
//  EveryTipDesignSystem
//
//  Created by 김경록 on 7/8/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public enum FontStyle {
    ///weight: 400
    case regular
    ///weight: 500
    case medium
    ///weight: 600
    case bold
    ///weight: 700
    case semiBold
    ///weight: 800
    case extraBold
}

extension UIFont {
    public static func et_pretendard(style: FontStyle, size: CGFloat) -> UIFont {
        switch style {
        case .regular:
            EveryTipDesignSystemFontFamily.Pretendard.regular.font(size: size)
        case .medium:
            EveryTipDesignSystemFontFamily.Pretendard.medium.font(size: size)
        case.bold: EveryTipDesignSystemFontFamily.Pretendard.bold.font(size: size)
        case .semiBold:
            EveryTipDesignSystemFontFamily.Pretendard.semiBold.font(size: size)
        case .extraBold:
            EveryTipDesignSystemFontFamily.Pretendard.extraBold.font(size: size)
        }
    }
}
