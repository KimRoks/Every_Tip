//
//  MyProfileDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation
import EveryTipDomain

public struct MyProfileDTO: Decodable {
    public let code: String
    public let message: String
    public let data: Data?
    
    public struct Data: Decodable {
        public let id: Int
        public let status: Int
        public let nickName: String
        public let profileImageURL: String?
        public let email: String
        public let registeredDate: String
        public let tipCount: Int
        public let savedTipCount: Int
        public let subscriberCount: Int

        enum CodingKeys: String, CodingKey {
            case id, status
            case nickName = "nick_name"
            case profileImageURL = "profile_image"
            case email
            case registeredDate = "registered_date"
            case tipCount = "tip_count"
            case savedTipCount = "saved_tip_count"
            case subscriberCount = "subscriber_count"
        }
    }
}

extension MyProfileDTO {
    func toDomain() -> MyProfile? {
        guard let data = data else { return nil }
        return MyProfile(
            id: data.id,
            status: data.status,
            nickName: data.nickName,
            profileImageURL: data.profileImageURL,
            email: data.email,
            registeredDate: data.registeredDate,
            tipCount: data.tipCount,
            savedTipCount: data.savedTipCount,
            subscriberCount: data.subscriberCount
        )
    }
}
