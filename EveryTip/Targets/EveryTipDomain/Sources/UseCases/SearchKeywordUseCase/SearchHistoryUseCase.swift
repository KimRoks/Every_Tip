//
//  SearchHistoryUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 7/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public protocol SearchHistoryUseCase {
    func fetchKeywords() -> [String]
    func addKeyword(_ keyword: String)
    func removeKeyword(_ keyword: String)
    func clearKeywords()
}

public final class DefaultSearchHistoryUseCase: SearchHistoryUseCase
{
    private let SearchHistoryRepository: SearchHistoryRepository
    
    init(searchHistoryRepository: SearchHistoryRepository) {
        self.SearchHistoryRepository = searchHistoryRepository
    }
    
    public func fetchKeywords() -> [String] {
        SearchHistoryRepository.fetchKeywords()
    }
    
    public func addKeyword(_ keyword: String) {
        SearchHistoryRepository.addKeyword(keyword)
    }
    
    public func removeKeyword(_ keyword: String) {
        SearchHistoryRepository.removeKeyword(keyword)
    }
    
    public func clearKeywords() {
        SearchHistoryRepository.clearKeywords()
    }
}
