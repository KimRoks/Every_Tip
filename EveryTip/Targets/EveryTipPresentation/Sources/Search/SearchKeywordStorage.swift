//
//  SearchKeywordStorage.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/25/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

// TODO: 아키텍처 기반 레이어 고민필요

final class SearchKeywordStorage {
    private let key = "recentSearchKeywords"
    private let maxCount = 10

    var keywords: [String] {
        get {
            UserDefaults.standard.stringArray(forKey: key) ?? []
        }
        set {
            let limited = Array(newValue.prefix(maxCount))
            UserDefaults.standard.set(limited, forKey: key)
        }
    }

    func add(_ keyword: String) {
        var current = keywords.filter { $0 != keyword }
        current.insert(keyword, at: 0)
        self.keywords = current
    }

    func remove(_ keyword: String) {
        var current = keywords
        current.removeAll { $0 == keyword }
        keywords = current
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
