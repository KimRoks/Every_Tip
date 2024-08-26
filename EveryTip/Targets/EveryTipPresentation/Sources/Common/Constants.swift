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
    
    public struct Category {
        public struct categoryCellItems {
            public let image: UIImage?
            public let title: String
            public let color: UIColor
        }
        
        public static let tableViewItems: [categoryCellItems] = [
            hobby,
            it,
            health,
            finance,
            entertainment,
            sports,
            games,
            social
        ]
        
        private static let hobby = categoryCellItems(
            image: UIImage(systemName: "house.fill"),
            title: "취미/생활",
            color: UIColor(
                red: 0.59,
                green: 0.74,
                blue: 0.35,
                alpha: 1.00
            )
        )
        
        private static let it = categoryCellItems(
            image: UIImage(systemName: "globe"),
            title: "IT",
            color: UIColor(
                red: 0.31,
                green: 0.51,
                blue: 0.90,
                alpha: 1.00
            )
        )
        
        private static let health = categoryCellItems(
            image: UIImage(systemName: "heart.fill"),
            title: "건강",
            color: UIColor(
                red: 0.87,
                green: 0.39,
                blue: 0.36,
                alpha: 1.00
            )
        )
        
        private static let finance = categoryCellItems(
            image: UIImage(systemName: "creditcard.fill"),
            title: "금융",
            color: UIColor(
                red: 0.96,
                green: 0.79,
                blue: 0.52,
                alpha: 1.00
            )
        )
        
        private static let entertainment = categoryCellItems(
            image: UIImage(systemName: "play.square.fill"),
            title: "연예/방송",
            color: UIColor(
                red: 0.88,
                green: 0.53,
                blue: 0.66,
                alpha: 1.00
            )
        )
        
        private static let sports = categoryCellItems(
            image: UIImage(systemName: "dumbbell.fill"),
            title: "스포츠",
            color: UIColor(
                red: 0.34,
                green: 0.40,
                blue: 0.53,
                alpha: 1.00
            )
        )
        
        private static let games = categoryCellItems(
            image: UIImage(systemName: "gamecontroller.fill"),
            title: "게임",
            color: UIColor(
                red: 0.67,
                green: 0.67,
                blue: 0.67,
                alpha: 1.00
            )
        )
        
        private static let social = categoryCellItems(
            image: UIImage(systemName: "antenna.radiowaves.left.and.right"),
            title: "사회",
            color: UIColor(
                red: 0.58,
                green: 0.54,
                blue: 0.69,
                alpha: 1.00
            )
        )
    }
}
