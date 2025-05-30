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
    
    func timeAgo() -> String? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        guard let inputDate = formatter.date(from: self) else {
            return nil
        }
        
        let now = Date() // 보정 없이 현재 시각 사용

        let calendar = Calendar.current
        let components = calendar.dateComponents(
            [.year, .month, .weekOfYear, .day, .hour, .minute],
            from: inputDate,
            to: now
        )
        
        if let years = components.year, years > 0 {
            return "\(years)년 전"
        } else if let months = components.month, months > 0 {
            return "\(months)개월 전"
        } else if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks)주 전"
        } else if let days = components.day, days > 0 {
            return "\(days)일 전"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)시간 전"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)분 전"
        } else {
            return "방금 전"
        }
    }
}
