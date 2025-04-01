//
//  MyProfile.swift
//  EveryTipDomain
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct MyProfile {
    public let id: Int
    public let status: Int
    public let nickName: String
    public let profileImage: String?
    public let email: String
    public let registeredDate: String
    public let tipCount: Int
    public let savedTipCount: Int
    public let subscriberCount: Int
    
    public init(
        id: Int,
        status: Int,
        nickName: String,
        profileImage: String?,
        email: String,
        registeredDate: String,
        tipCount: Int,
        savedTipCount: Int,
        subscriberCount: Int
    ) {
        self.id = id
        self.status = status
        self.nickName = nickName
        self.profileImage = profileImage
        self.email = email
        self.registeredDate = registeredDate
        self.tipCount = tipCount
        self.savedTipCount = savedTipCount
        self.subscriberCount = subscriberCount
    }
}
