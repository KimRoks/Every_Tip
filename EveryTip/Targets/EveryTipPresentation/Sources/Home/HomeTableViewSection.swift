//
//  HomeTableViewSection.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/24/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import RxDataSources

struct HomeTableViewSection {
    var sectionType: SectionType
    var items: [Tip]

    enum SectionType {
        case popular
        case interestCategory
        
        var hederTitle: String {
            switch self {
            case .popular:
                return "인기 팁 모아보기 🔥"
            case .interestCategory:
                return "관심 카테고리~ 추천 팁 영역 🔍"
            }
        }
    }
}

extension HomeTableViewSection: SectionModelType {
    typealias Item = Tip
    
    init(original: HomeTableViewSection, items: [Item]) {
        self = original
        self.items = items
    }
}
