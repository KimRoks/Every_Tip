//
//  CommentRepository.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol CommentRepository {
    func fetchComments(for tipID: Int) -> Single<[Comment]?>
    
    func postComment(
        content: String,
        tipID: Int,
        parentID: Int?
    ) -> Completable
  
    func deleteComment(for commentID: Int) -> Completable
    
    func likeComment(for commentID: Int) -> Completable
}
