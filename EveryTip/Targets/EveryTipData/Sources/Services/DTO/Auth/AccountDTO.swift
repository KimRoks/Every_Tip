//
//  AccountDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

public struct AccountResponse: Decodable {
    public let statusCode: Int
    public let code: String
    public let message: String
    public let data: AccountDTO
}

public struct AccountDTO: Decodable {
    public let id: Int
    public let email: String?
    public let nickName: String?
    public let accessToken: String
    public let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case id, email
        case nickName = "nick_name"
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

extension AccountDTO {
    func toDomain() -> Account {
        return Account(
            id: id,
            email: email,
            nickName: nickName,
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
