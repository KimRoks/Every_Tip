//
//  RenewTokenDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 7/11/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//
import Foundation

import EveryTipDomain

public struct RenewTokenDTO: Decodable {
    public let code: String
    public let message: String
    public let data: AuthData
}

public struct AuthData: Decodable {
    public let id: Int
    public let email: String
    public let nickName: String
    public let isUserDeactivated: Bool
    public let accessToken: String
    public let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case nickName = "nick_name"
        case isUserDeactivated = "is_user_deativated"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
