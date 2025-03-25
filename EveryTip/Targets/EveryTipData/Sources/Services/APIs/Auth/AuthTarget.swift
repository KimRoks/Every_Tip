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
    case postUserLogin(email: String, password: String)
    case postVerificationEmail(email: String)
    case getCheckVerificationCode(code: String)
}

extension AuthTarget: TargetType {
    var method: HTTPMethods {
        switch self {
        case .getAgreements:
                .get
        case .postUserLogin:
                .post
        case .postVerificationEmail:
                .post
        case .getCheckVerificationCode:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .getAgreements:
            return "/auth/agreements"
        case .postUserLogin:
            return "/auth/sign-in"
        case .postVerificationEmail:
            return "/auth/verification/email"
        case .getCheckVerificationCode:
            return "/auth/verification"
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .getAgreements:
            return nil
        case .postUserLogin(email: let email, password: let password):
            return ["email": email, "password": password]
        case .postVerificationEmail(email: let email):
            return ["email": email]
        case .getCheckVerificationCode(let code):
            return ["code": code]
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getAgreements:
            return nil
        case .postUserLogin:
            return ["Content-Type": "application/json"]
        case .postVerificationEmail:
            return ["Content-Type": "application/json"]
        case .getCheckVerificationCode:
            return nil
        }
    }
}
