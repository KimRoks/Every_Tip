//
//  Account.swift
//  EveryTipDomain
//
//  Created by 김경록 on 10/28/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct Account: Identifiable {
    public let id: Int
    public let email: String?
    public let nickName: String?
    public let accessToken: String
    public let refreshToken: String
    
    public init(
        id: Int,
        email: String?,
        nickName: String?,
        accessToken: String,
        refreshToken: String
    ) {
        self.id = id
        self.email = email
        self.nickName = nickName
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
