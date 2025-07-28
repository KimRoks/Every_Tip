//
//  SearchHistoryRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 7/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public protocol SearchHistoryRepository {
    func fetchKeywords() -> [String]
    func addKeyword(_ keyword: String)
    func removeKeyword(_ keyword: String)
    func clearKeywords()
}
