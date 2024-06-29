//
//  FetchPostUseCase.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/24/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol FetchPostUseCase {
    func fetchPosts() -> Single<[Tip]>
}
