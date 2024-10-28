//
//  UIColor+.swift
//  EveryTipDesignSystem
//
//  Created by 김경록 on 7/3/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

extension UIColor {
    /// 색상 코드: #43AC75
    public static let et_brandColor1 = UIColor(red: 0.26, green: 0.67, blue: 0.46, alpha: 1.00)
    /// 색상 코드: #5ACC90
    public static let et_brandColor2 = UIColor(red: 0.35, green: 0.80, blue: 0.56, alpha: 1.00)
    /// 색상 코드: #F1F1F1
    public static let et_brandColor4 = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
    
    /// 색상 코드: #BEC1C8
    public static let et_textColor5 = UIColor(red: 0.75, green: 0.76, blue: 0.78, alpha: 1.00)
    
    /// 색상코드: #000000
    public static let et_textColorBlack100 = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
    
    /// 색상 코드: #111111
    public static let et_textColorBlack90 = UIColor(red: 0.07, green: 0.07, blue: 0.07, alpha: 1.00)
    
    /// 색상 코드: #333333
    public static let et_textColorBlack70 = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
    
    /// 색상 코드: #555555
    public static let et_textColorBlack50 = UIColor(red: 0.33, green: 0.33, blue: 0.33, alpha: 1.00)
    
    /// 색상 코드: #777777
    public static let et_textColorBlack30 = UIColor(red: 0.47, green: 0.47, blue: 0.47, alpha: 1.00)
    
    /// 색상 코드: #999999
    public static let et_textColorBlack10 = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.00)
    
    
    /// 색상코드: #E1E1E1
    public static let et_lineGray40 = UIColor(red: 0.88, green: 0.88, blue: 0.88, alpha: 1.00)
    
    /// 색상코드: #F1F1F1
    public static let et_lineGray30 = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
    
    /// 색상코드: #F6F6F6
    public static let et_lineGray20 = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    
    /// 색상코드: #FBFBFB
    public static let et_lineGray10 = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
}

extension UIColor {
    /**
     16진수 컬러 컨스트럭터
     
     ~~~ swift
     // example
     UIColor(hex: "#000000")
     ~~~
     */
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        ).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
