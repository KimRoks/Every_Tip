//
//  PostListModel.swift
//  EveryTipDomain
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol PostRepository {
    func fetchPosts() -> Single<[Tip]>
}
