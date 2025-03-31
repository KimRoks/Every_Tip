//
//  UserTarget.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

enum UserTarget {
    case getRandomNickName
    case postSetCategory(categoryIDs: [Int])
    case getMyProfile
    case getUserProfile(userID: Int)
}

extension UserTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .getRandomNickName:
                .get
        case .postSetCategory:
                .post
        case .getMyProfile:
                .get
        case .getUserProfile:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .getRandomNickName:
            return "/user/nick-name"
        case .postSetCategory:
            return "/user/main-category"
        case .getMyProfile:
            return "/user/my-profile"
        case .getUserProfile(userID: let userID):
            return "/user/\(userID)"
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getRandomNickName:
            return nil
        case .postSetCategory:
            return ["Content-Type": "application/json"]
        case .getMyProfile:
            return nil
        case .getUserProfile:
            return nil
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getRandomNickName:
            return nil
        case .postSetCategory(categoryIDs: let categoryIDs):
            return ["category_ids": categoryIDs]
        case .getMyProfile:
            return nil
        case .getUserProfile:
            return nil
        }
    }
}

