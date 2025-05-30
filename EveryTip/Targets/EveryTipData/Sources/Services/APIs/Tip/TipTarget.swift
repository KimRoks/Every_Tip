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
        }
    }
}
