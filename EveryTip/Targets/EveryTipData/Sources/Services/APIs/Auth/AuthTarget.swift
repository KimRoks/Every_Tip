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
    case postRequestVerificationCode(email: String)
    case postUserLogin(email: String, password: String)
    case getCheckVerificationCode(code: String)
}

extension AuthTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .getAgreements:
                .get
        case .postRequestVerificationCode:
                .post
        case .postUserLogin:
                .post
        case .getCheckVerificationCode:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .getAgreements:
            return "/auth/agreements"
        case .postRequestVerificationCode:
            return "/auth/verification/email"
        case .postUserLogin:
            return "/auth/sign-in"
        case .getCheckVerificationCode(let code):
            return "/auth/verification?code=\(code)"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAgreements:
            return nil
        case .postRequestVerificationCode(let email):
            return ["email": email]
        case .postUserLogin(email: let email, password: let password):
            return ["email": email, "password": password]
        case .getCheckVerificationCode:
           return nil
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAgreements:
            return nil
        case .postRequestVerificationCode:
            return ["Content-Type": "application/json"]
        case .postUserLogin:
            return ["Content-Type": "application/json"]
        case .getCheckVerificationCode:
            return nil
        }
    }
}
