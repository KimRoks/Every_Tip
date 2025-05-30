//
//  CommentUseCase.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public protocol CommentUseCase {
    func fetchComments(tipID: Int) -> Single<[Comment]?>
    func postComment(
        content: String,
        tipID: Int,
        parentID: Int?
    ) -> Completable
    func deleteComment(commentId: Int) -> Completable
}

final class DefaultCommentUseCase: CommentUseCase {
    
    private let commentRepository: CommentRepository
    
    init(commentRepository: CommentRepository) {
        self.commentRepository = commentRepository
    }
    
    func fetchComments(tipID: Int) -> Single<[Comment]?> {
        commentRepository.fetchComments(tipID: tipID)
    }
    
    func postComment(
        content: String,
        tipID: Int,
        parentID: Int?
    ) -> Completable {
        commentRepository.postComment(
            content: content,
            tipID: tipID,
            parentID: parentID
        )
    }
    
    func deleteComment(commentId: Int) -> Completable {
        commentRepository.deleteComment(commentId: commentId)
    }
}
