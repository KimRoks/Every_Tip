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
    case postLikeTip(tipID: Int)
    case postSaveTip(tipID: Int)
    case deleteTip(tipID: Int)
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
        }
    }
}
