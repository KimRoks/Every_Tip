//
//  User.swift
//  EveryTipDomain
//
//  Created by 김경록 on 8/3/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct User: Decodable {
    public let code: String
    public let message: String
    public let data: UserData
}

public struct UserData: Decodable {
    public let isLogined: Bool?
    public let userProfile: UserProfile
    
    enum CodingKeys: String, CodingKey {
        case isLogined = "is_logined"
        case userProfile = "user_profile"
    }
}

public struct UserProfile: Decodable, Identifiable {
    public let id: Int
    public let status: Int
    public let nickName: String
    public let profileImage: Data?
    public let email: String
    public let registeredDate: String
    public let tipCount: Int
    public let subscriberCount: Int
    public let isMyProfile: Bool?
    public let isFollowing: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, status
        case nickName = "nick_name"
        case profileImage = "profile_image"
        case email
        case registeredDate = "registered_date"
        case tipCount = "tip_count"
        case subscriberCount = "subscriber_count"
        case isMyProfile = "is_my_profile"
        case isFollowing = "is_following"
    }
}
