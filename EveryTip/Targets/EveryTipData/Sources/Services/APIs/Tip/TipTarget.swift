//
//  TipTarget.swift
//  EveryTipData
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

enum TipTarget {
    case fetchTotalTip
    case fetchTipByTipID(Int)
    case fetchTipByUserID(Int)
    case postLikeTip(tipID: Int)
    case postSaveTip(tipID: Int)
    case deleteTip(tipID: Int)
    case getSavedTips
}

extension TipTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .fetchTotalTip:
                .get
        case .fetchTipByTipID:
                .get
        case .fetchTipByUserID:
                .get
        case .deleteTip:
                .delete
        case .postLikeTip:
                .post
        case .postSaveTip:
                .post
        case .getSavedTips:
                .get
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
        case .deleteTip(tipID: let tipID):
            return "/tips?id=\(tipID)"
        case .postLikeTip(tipID: let tipID):
            return "/tips/\(tipID)/likes"
        case .postSaveTip(tipID: let tipID):
            return "/tips/\(tipID)/save"
        case .getSavedTips:
            return "/user/saved-tips"
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
        case .getSavedTips:
            return nil
        case .fetchTipByUserID:
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
        case .getSavedTips:
            return nil
        case .fetchTipByUserID:
            return nil
        }
    }
}
