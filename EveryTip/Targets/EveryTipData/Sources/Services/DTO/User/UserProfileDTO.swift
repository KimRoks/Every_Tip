//
//  ProfileDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

struct UserProfileResponse: Decodable {
    let code: String
    let message: String
    let data: UserProfileData
}

struct UserProfileData: Decodable {
    let isLogined: Bool
    let userProfile: UserProfileDTO

    enum CodingKeys: String, CodingKey {
        case isLogined = "is_logined"
        case userProfile = "user_profile"
    }
}

struct UserProfileDTO: Decodable {
    let id: Int
    let status: Int
    let nickName: String
    let profileImage: String?
    let email: String
    let registeredDate: String
    let tipCount: Int
    let subscriberCount: Int
    let isMyProfile: Bool
    let isFollowing: Bool
    
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

extension UserProfileDTO {
    func toDomain() -> UserProfile {
        UserProfile(
            id: id,
            status: status,
            nickName: nickName,
            profileImage: profileImage,
            email: email,
            registeredDate: registeredDate,
            tipCount: tipCount,
            subscriberCount: subscriberCount,
            isMyProfile: isMyProfile,
            isFollowing: isFollowing
        )
    }
}
