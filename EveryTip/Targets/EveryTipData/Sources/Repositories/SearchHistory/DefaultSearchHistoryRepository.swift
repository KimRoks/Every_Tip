//
//  DefaultSearchHistoryRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 7/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

struct DefaultSearchHistoryRepository: SearchHistoryRepository {
    private let key = "recentSearchKeywords"
    private let maxCount = 10

    func fetchKeywords() -> [String] {
        UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func addKeyword(_ keyword: String) {
        var current = fetchKeywords().filter { $0 != keyword }
        current.insert(keyword, at: 0)
        let limited = Array(current.prefix(maxCount))
        UserDefaults.standard.set(limited, forKey: key)
    }

    func removeKeyword(_ keyword: String) {
        var current = fetchKeywords()
        current.removeAll { $0 == keyword }
        UserDefaults.standard.set(current, forKey: key)
    }

    func clearKeywords() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
