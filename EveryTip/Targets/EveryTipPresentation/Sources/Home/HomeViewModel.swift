//
//  HomeViewModel.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import RxSwift

final class HomeViewModel {
    private let postUseCase: PostListUseCase
    private let disposeBag = DisposeBag()
    
    init(postUseCase: PostListUseCase) {
        self.postUseCase = postUseCase
        fetchPosts()
    }
    
    public let posts: BehaviorSubject<[PostListModel]> = BehaviorSubject(value: [])
    
    public func fetchPosts() {
        postUseCase.fetchPost()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] posts in
                    self?.posts.onNext(posts)
                },
                onFailure: { error in
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
