//
//  UserProfileDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

public struct UserProfileDTO: Decodable {
    public let code: String
    public let message: String
    public let data: Data?
    
    public struct Data: Decodable {
        public let isLogined: Bool
        public let userProfile: UserProfileData?

        enum CodingKeys: String, CodingKey {
            case isLogined = "is_logined"
            case userProfile = "user_profile"
        }
        
        public struct UserProfileData: Decodable {
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
            
            enum CodingKeys: String, CodingKey {
                case id, status
                case nickName = "nick_name"
                case profileImageURL = "profile_image"
                case email
                case registeredDate = "registered_date"
                case tipCount = "tip_count"
                case subscriberCount = "subscriber_count"
                case isMyProfile = "is_my_profile"
                case isFollowing = "is_following"
            }
            
            func toDomain() -> UserProfile {
                return UserProfile(
                    id: id,
                    status: status,
                    nickName: nickName,
                    profileImageURL: profileImageURL,
                    email: email,
                    registeredDate: registeredDate,
                    tipCount: tipCount,
                    subscriberCount: subscriberCount,
                    isMyProfile: isMyProfile,
                    isFollowing: isFollowing
                )
            }
        }
    }
}
