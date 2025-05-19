//
//  TipRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol TipRepository {
    func fetchTotalTips() -> Single<[Tip]>
}
