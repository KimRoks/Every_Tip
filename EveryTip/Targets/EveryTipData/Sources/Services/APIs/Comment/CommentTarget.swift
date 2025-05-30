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
}

extension CommentTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .getComments:
                return .get
        case .postComment:
                return .post
        }
    }
    
    var path: String {
        switch self {
        case .getComments:
            return "/tips/comments"
        case .postComment:
            return "/tips/comments"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getComments:
            return nil
        case .postComment:
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
        }
    }
}
