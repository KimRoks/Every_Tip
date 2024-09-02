//
//  Constraint.swift
//  EveryTipDomain
//
//  Created by 김경록 on 8/5/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public struct Constants {
    public struct UserInfo {
        public static let tableViewItems: [String] = [
            "공지사항",
            "고객센터",
            "구독 설정",
            "관심사 설정",
            "이용약관",
            "버전",
            "로그아웃"
        ]
    }
    
    public enum Category: CaseIterable {
        case hobby
        case it
        case health
        case finance
        case entertainment
        case sports
        case games
        case social
        
        var image: UIImage? {
            switch self {
            case .hobby:
                return UIImage(systemName: "house.fill")
            case .it:
                return UIImage(systemName: "globe")
            case .health:
                return UIImage(systemName: "heart.fill")
            case .finance:
                return UIImage(systemName: "creditcard.fill")
            case .entertainment:
                return UIImage(systemName: "play.square.fill")
            case .sports:
                return UIImage(systemName: "dumbbell.fill")
            case .games:
                return UIImage(systemName: "gamecontroller.fill")
            case .social:
                return UIImage(systemName: "antenna.radiowaves.left.and.right")
            }
        }
        
        var title: String {
            switch self {
            case .hobby:
                return "취미/생활"
            case .it:
                return "IT"
            case .health:
                return "건강"
            case .finance:
                return "금융"
            case .entertainment:
                return "연예/방송"
            case .sports:
                return "스포츠"
            case .games:
                return "게임"
            case .social:
                return "사회"
            }
        }
        
        var color: UIColor {
            switch self {
            case .hobby:
                return UIColor(red: 0.59, green: 0.74, blue: 0.35, alpha: 1.00)
            case .it:
                return UIColor(red: 0.31, green: 0.51, blue: 0.90, alpha: 1.00)
            case .health:
                return UIColor(red: 0.87, green: 0.39, blue: 0.36, alpha: 1.00)
            case .finance:
                return UIColor(red: 0.96, green: 0.79, blue: 0.52, alpha: 1.00)
            case .entertainment:
                return UIColor(red: 0.88, green: 0.53, blue: 0.66, alpha: 1.00)
            case .sports:
                return UIColor(red: 0.34, green: 0.40, blue: 0.53, alpha: 1.00)
            case .games:
                return UIColor(red: 0.67, green: 0.67, blue: 0.67, alpha: 1.00)
            case .social:
                return UIColor(red: 0.58, green: 0.54, blue: 0.69, alpha: 1.00)
            }
        }
        
        public static let tableViewItems: [Category] = Category.allCases
    }
}
