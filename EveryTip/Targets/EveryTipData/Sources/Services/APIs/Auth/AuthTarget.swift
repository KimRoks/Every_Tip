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
    case postSignUp(
        email: String,
        password: String,
        agreementsIDs: [Int],
        nickName: String
    )
    case getCheckEmailDuplication(email: String)
    case patchUpdatePassword(email: String, password: String)
    case postRenewRefreshToken(currentToken: String)
    case deleteAccount
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
        case .postSignUp:
                .post
        case .getCheckEmailDuplication:
                .get
        case .patchUpdatePassword:
                .patch
        case .postRenewRefreshToken:
                .post
        case .deleteAccount:
                .delete
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
        case .postSignUp:
            return "/auth/sign-up"
        case .getCheckEmailDuplication:
            return "/auth/email-check"
        case .patchUpdatePassword:
            return "/auth/password"
        case .postRenewRefreshToken:
            return "/auth/sign-in/refresh-tokens"
        case .deleteAccount:
            return "/user"
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
        case .postSignUp(
            email: let email,
            password: let password,
            agreementsIDs: let agreementsIDs,
            nickName: let nickName
        ):
            return [
                "email": email,
                "password": password,
                "agreement_ids": agreementsIDs,
                "nick_name": nickName
            ]
        case .getCheckEmailDuplication(email: let email):
            return ["email": email]
        case .patchUpdatePassword(email: let email, password: let password):
            return ["email": email, "password": password]
        case .postRenewRefreshToken(currentToken: let currentToken):
            return ["refresh_token" : currentToken]
        case .deleteAccount:
            return nil
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
        case .postSignUp:
            return ["Content-Type": "application/json"]
        case .getCheckEmailDuplication:
            return ["Content-Type": "application/json"]
        case .patchUpdatePassword:
            return ["Content-Type": "application/json"]
        case .postRenewRefreshToken:
            return nil
        case .deleteAccount:
            return nil
        }
    }
}
