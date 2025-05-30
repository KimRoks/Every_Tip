//
//  CommentTarget.swift
//  EveryTipData
//
//  Created by 김경록 on 5/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

enum CommentTarget {
    case getComments(tipID: Int)
    case postComment(
        content: String,
        tipID: Int,
        parentID: Int?
    )
    case deleteComment(commentID: Int)
}

extension CommentTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .getComments:
                return .get
        case .postComment:
                return .post
        case .deleteComment:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .getComments:
            return "/tips/comments"
        case .postComment:
            return "/tips/comments"
        case .deleteComment(let commentID):
            return "/tips/comments?comment_id=\(commentID)"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getComments:
            return nil
        case .postComment:
            return nil
        case .deleteComment:
            return nil
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getComments(let tipID):
            return [
                "tip_id": tipID
            ]
        case .postComment(content: let content, tipID: let tipID, parentID: let parentID):
            return [
                "content": content,
                "tip_id": tipID,
                "parent_id": parentID
            ]
        case .deleteComment:
            return nil
        }
    }
}
