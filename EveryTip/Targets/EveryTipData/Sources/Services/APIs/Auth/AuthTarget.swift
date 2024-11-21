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
    case requestToken(email: String, password: String)
}

extension AuthTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .getAgreements:
                .get
        case .requestEmailCode:
                .post
        case .requestToken:
                .post
        }
    }
    
    var path: String {
        switch self {
        case .getAgreements:
            return "/auth/agreements"
        case .requestEmailCode:
            return "/auth/verification/email"
        case .requestToken:
            return "/auth/sign-in"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAgreements:
            return nil
        case .requestEmailCode(let email):
            return ["email": email]
        case .requestToken(email: let email, password: let password):
            return ["email": email, "password": password]
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAgreements:
            return nil
        case .requestEmailCode:
            return ["Content-Type": "application/json"]
        case .requestToken:
            return ["Content-Type": "application/json"]
        }
    }
}
