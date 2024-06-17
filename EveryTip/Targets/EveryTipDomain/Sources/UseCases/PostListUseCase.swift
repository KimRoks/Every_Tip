//
//  PostUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol PostListUseCase {
    func fetchPosts() -> Single<[Tip]>
}

final public class DefaultPostListUseCase: PostListUseCase {
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository) {
        self.postRepository = postRepository
    }
    
    public func fetchPosts() -> Single<[Tip]> {
        return postRepository.fetchPosts()
    }
}
