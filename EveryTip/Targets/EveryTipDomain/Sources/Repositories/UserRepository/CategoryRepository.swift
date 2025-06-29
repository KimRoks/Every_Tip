//
//  CategoryRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 3/28/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol CategoryRepository {
    func fetchMyCategories() -> Single<[Category]>
    func setMyCategories(categoryIDs: [Int]) -> Completable
}
