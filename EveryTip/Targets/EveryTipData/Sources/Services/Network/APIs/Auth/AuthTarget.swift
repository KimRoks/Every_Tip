//
//  File.swift
//  EveryTipData
//
//  Created by 김경록 on 9/15/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import Alamofire

enum AuthTarget {
    case getAgreements
    case requestEmailCode(email: String)
}

extension AuthTarget: TargetType {
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getAgreements:
                .get
        case .requestEmailCode:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .getAgreements:
            return Paths.agreements.description
        case .requestEmailCode:
            return Paths.requestEmail.description
        }
    }

    var parameters: Alamofire.Parameters? {
        get {
            switch self {
            case .getAgreements:
                return nil
            case .requestEmailCode(let email):
                return ["email": email]
            }
        }
    }
}
