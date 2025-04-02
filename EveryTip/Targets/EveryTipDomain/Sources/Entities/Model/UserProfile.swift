//
//  UserProfile.swift
//  EveryTipDomain
//
//  Created by 김경록 on 8/3/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct UserProfile {
    public let id: Int
    public let status: Int
    public let nickName: String
    public let profileImageURL: String?
    public let email: String
    public let registeredDate: String
    public let tipCount: Int
    public let subscriberCount: Int
    public let isMyProfile: Bool
    public let isFollowing: Bool
    
    public init(
        id: Int,
        status: Int,
        nickName: String,
        profileImageURL: String?,
        email: String,
        registeredDate: String,
        tipCount: Int,
        subscriberCount: Int,
        isMyProfile: Bool,
        isFollowing: Bool
    ) {
        self.id = id
        self.status = status
        self.nickName = nickName
        self.profileImageURL = profileImageURL
        self.email = email
        self.registeredDate = registeredDate
        self.tipCount = tipCount
        self.subscriberCount = subscriberCount
        self.isMyProfile = isMyProfile
        self.isFollowing = isFollowing
    }
}
