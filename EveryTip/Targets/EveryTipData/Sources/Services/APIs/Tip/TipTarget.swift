//
//  TipTarget.swift
//  EveryTipData
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation
import EveryTipDomain

enum TipTarget {
    case fetchTotalTip
    case fetchTipByTipID(Int)
    case postLikeTip(tipID: Int)
    case postSaveTip(tipID: Int)
    case deleteTip(tipID: Int)
    case postPresignedURL(
        categoryID: Int,
        fileType: String
    )
    case postTip(
        categoryID: Int,
        tags: [String],
        title: String,
        content: String,
        images: [Tip.Image]
    )
}

extension TipTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .fetchTotalTip:
                .get
        case .fetchTipByTipID:
                .get
        case .deleteTip:
                .delete
        case .postLikeTip:
                .post
        case .postSaveTip:
                .post
       
        case .postTip:
                .post
        case .postPresignedURL:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchTotalTip:
            return "/tips"
        case .fetchTipByTipID(let tipID):
            return "/tips?tip_id=\(tipID)"
        case .deleteTip(tipID: let tipID):
            return "/tips?id=\(tipID)"
        case .postLikeTip(tipID: let tipID):
            return "/tips/\(tipID)/likes"
        case .postSaveTip(tipID: let tipID):
            return "/tips/\(tipID)/save"
        case .postTip:
            return "/tips"
        case .postPresignedURL:
            return "/tips/image/url"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchTotalTip:
            return nil
        case .fetchTipByTipID:
            return nil
        case .deleteTip:
            return nil
        case .postLikeTip:
            return nil
        case .postSaveTip:
            return nil
        case .postTip:
            return nil
        case .postPresignedURL:
            return nil
        }
    }
        
    var parameters: [String : Any]? {
        switch self {
        case .fetchTotalTip:
            return nil
        case .fetchTipByTipID:
            return nil
        case .deleteTip:
            return nil
        case .postLikeTip:
            return nil
        case .postSaveTip:
            return nil
        case .postTip(
            categoryID: let categoryID,
            tags: let tags,
            title: let title,
            content: let content,
            images: let images
        ):
            return [
                "category_id" : categoryID,
                "tags" : tags,
                "title": title,
                "content": content,
                "images": images.map{
                    ["url": $0.url,
                     "is_thumbnail": $0.isThumbnail
                    ]
                }
            ]
        case .postPresignedURL(categoryID: let categoryID, fileType: let fileType):
            return [
                "category_id" : categoryID,
                "file_type": fileType
            ]
        }
    }
}
