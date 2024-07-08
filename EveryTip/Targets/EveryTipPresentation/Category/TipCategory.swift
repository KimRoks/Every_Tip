//
//  TipCategory.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/8/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

struct TipCategory {
    let image: UIImage?
    let title: String
    let color: UIColor
    
    static let hobby = TipCategory(
        image: UIImage(systemName: "house.fill"),
        title: "취미/생활",
        color: UIColor(
            red: 0.59,
            green: 0.74,
            blue: 0.35,
            alpha: 1.00
        )
    )
    
    static let it = TipCategory(
        image: UIImage(systemName: "globe"),
        title: "IT",
        color: UIColor(
            red: 0.31,
            green: 0.51,
            blue: 0.90,
            alpha: 1.00
        )
    )
    
    static let health = TipCategory(
        image: UIImage(systemName: "heart.fill"),
        title: "건강",
        color: UIColor(
            red: 0.87,
            green: 0.39,
            blue: 0.36,
            alpha: 1.00
        )
    )
    
    static let finance = TipCategory(
        image: UIImage(systemName: "creditcard.fill"),
        title: "금융",
        color: UIColor(
            red: 0.96,
            green: 0.79,
            blue: 0.52,
            alpha: 1.00
        )
    )
    
    static let entertainment = TipCategory(
        image: UIImage(systemName: "play.square.fill"),
        title: "연예/방송",
        color: UIColor(
            red: 0.88,
            green: 0.53,
            blue: 0.66,
            alpha: 1.00
        )
    )
    
    static let sports = TipCategory(
        image: UIImage(systemName: "dumbbell.fill"),
        title: "스포츠",
        color: UIColor(
            red: 0.34,
            green: 0.40,
            blue: 0.53,
            alpha: 1.00
        )
    )
    
    static let games = TipCategory(
        image: UIImage(systemName: "gamecontroller.fill"),
        title: "게임",
        color: UIColor(
            red: 0.67,
            green: 0.67,
            blue: 0.67,
            alpha: 1.00
        )
    )
    
    static let social = TipCategory(
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
