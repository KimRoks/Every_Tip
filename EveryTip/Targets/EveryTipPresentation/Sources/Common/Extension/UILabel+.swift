//
//  UILabel+.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/3/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

// TODO: 추후 api가 카테고리를 어떻게 뱉어주냐에 따라 Int등 rawValue갖게끔 변경할수도 있음
enum categorys {
    case hobby
    case life
    case it
    case health
    case financial
    case entertainments
    case broadcast
    case sports
    case games
    case social
}

extension UILabel {
    func setCategoryLabel(category: categorys) {
        applyCommonStyle()
        
        switch category {
        //Text 뒤 문자는 일괄적이고 자연스러운 공백을 위한 유니코드임
        case .hobby:
            text = "취미\u{2003}"
            backgroundColor = UIColor(hex: "#E5F7F4")
            textColor = UIColor(hex: "#179780")
        case .life:
            text = "생활\u{2003}"
            backgroundColor = UIColor(hex: "#ECF9F2")
            textColor = UIColor(hex: "#26BA6C")
        case .it:
            text = "IT\u{2003}"
            backgroundColor = UIColor(hex: "#F1F6FF")
            textColor = UIColor(hex: "#4581DD")
        case .health:
            text = "건강\u{2003}"
            backgroundColor = UIColor(hex: "#FFF0F0")
            textColor = UIColor(hex: "#C34038")
        case .financial:
            text = "금융\u{2003}"
            backgroundColor = UIColor(hex: "#FFF9E3")
            textColor = UIColor(hex: "#EA9B22")
        case .entertainments:
            text = "연예\u{2003}"
            backgroundColor = UIColor(hex: "#FFF2F7")
            textColor = UIColor(hex: "#E2407B")
        case .broadcast:
            text = "방송\u{2003}"
            backgroundColor = UIColor(hex: "#FCF0F9")
            textColor = UIColor(hex: "#CD4285")
        case .sports:
            text = "스포츠\u{2003}"
            backgroundColor = UIColor(hex: "#F1F4FF")
            textColor = UIColor(hex: "#3E5075")
        case .games:
            text = "게임\u{2003}"
            backgroundColor = UIColor(hex: "#F4F4F4")
            textColor = UIColor(hex: "#787878")
        case .social:
            text = "사회\u{2003}"
            backgroundColor = UIColor(hex: "#F9F3FF")
            textColor = UIColor(hex: "#74629C")
        }
    }
    
    private func applyCommonStyle() {
        font = UIFont.et_pretendard(
            style: .bold,
            size: 12
        )
        layer.cornerRadius = 4
        layer.masksToBounds = true
        textAlignment = .center
    }
}


