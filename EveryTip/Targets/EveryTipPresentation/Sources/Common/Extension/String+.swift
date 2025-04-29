//
//  String+.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

enum TextType {
    case email
    case password
    case nickname
    case verifyCode
}

extension String {
    func checkRegex(type: TextType) -> Bool {
        switch type {
        case .verifyCode:
            return Int(self) != nil
        case .email:
            let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            return self.range(of: pattern, options: .regularExpression) != nil
        case .password:
            let pattern = "(?=.*[A-Za-z])(?=.*\\d).{8,}"
            return self.range(of: pattern, options: .regularExpression) != nil
        case .nickname:
            let pattern = "^[가-힣a-zA-Z0-9]*$"
            guard NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) else {
                return false
            }
            
            // 한글/영문 길이 체크
            let koreanCount = self.reduce(0) { $0 + ($1.isKorean ? 1 : 0) }
            let englishCount = self.reduce(0) { $0 + ($1.isEnglish ? 1 : 0) }
            
            if koreanCount > 0 {
                return koreanCount <= 8
            } else {
                return englishCount <= 12
            }
        }
    }
}
