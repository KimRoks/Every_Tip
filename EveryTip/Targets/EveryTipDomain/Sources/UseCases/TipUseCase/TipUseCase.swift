//
//  TipUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol TipUseCase {
    func fetchTotalTips() -> Single<[Tip]>
}

final class DefaultTipUseCase: TipUseCase {

    private let tipRepository: TipRepository
    
    init(tipRepository: TipRepository) {
        self.tipRepository = tipRepository
    }
    
    func fetchTotalTips() -> Single<[Tip]> {
        tipRepository.fetchTotalTips()
    }
}
