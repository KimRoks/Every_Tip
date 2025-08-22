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
    case fetchTipByUserID(Int)
    case postLikeTip(tipID: Int)
    case postSaveTip(tipID: Int)
    case deleteTip(tipID: Int)
    case getSavedTips
    case getSearchTips(keyword: String)
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
    case postReportTip(tipID: Int)
}

extension TipTarget: TargetType {
    
    var method: HTTPMethods {
        switch self {
        case .fetchTotalTip,
             .fetchTipByTipID,
             .fetchTipByUserID,
             .getSavedTips,
             .getSearchTips:
            return .get
        case .deleteTip:
            return .delete
        case .postLikeTip,
             .postSaveTip,
             .postTip,
             .postPresignedURL,
             .postReportTip:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchTotalTip:
            return "/tips"
        case .fetchTipByTipID(let tipID):
            return "/tips?tip_id=\(tipID)"
        case .fetchTipByUserID(let userID):
            return "/tips?user_id=\(userID)"
        case .deleteTip(let tipID):
            return "/tips?id=\(tipID)"
        case .postLikeTip(let tipID):
            return "/tips/\(tipID)/likes"
        case .postSaveTip(let tipID):
            return "/tips/\(tipID)/save"
        case .getSavedTips:
            return "/user/saved-tips"
        case .getSearchTips(let keyword):
            return "/tips/search?keyword=\(keyword)"
        case .postPresignedURL:
            return "/tips/image/url"
        case .postTip:
            return "/tips"
        case .postReportTip:
            return "/tips/report"
        }
    }
    
    var headers: [String : String]? {
        // 모두 기본값(nil) 사용
        return nil
    }
        
    var parameters: [String : Any]? {
        switch self {
        case .fetchTotalTip,
             .fetchTipByTipID,
             .fetchTipByUserID,
             .deleteTip,
             .postLikeTip,
             .postSaveTip,
             .getSavedTips,
             .getSearchTips:
            return nil
            
        case .postTip(let categoryID, let tags, let title, let content, let images):
            return [
                "category_id": categoryID,
                "tags": tags,
                "title": title,
                "content": content,
                "images": images.map {
                    [
                        "url": $0.url,
                        "is_thumbnail": $0.isThumbnail
                    ]
                }
            ]
            
        case .postPresignedURL(let categoryID, let fileType):
            return [
                "category_id": categoryID,
                "file_type": fileType
            ]
        case .postReportTip(tipID: let tipID):
            return [
                "tip_id": tipID
            ]
        }
    }
}
