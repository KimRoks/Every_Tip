//
//  MyProfileDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 3/31/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation
import EveryTipDomain

struct MyProfileResponse: Decodable {
    let code: String
    let message: String
    let data: MyProfileDTO?
}

struct MyProfileDTO: Decodable {
    let id, status: Int
    let nickName: String
    let profileImageURL: String?
    let email: String
    let registeredDate: String
    let tipCount: Int
    let savedTipCount: Int
    let subscriberCount: Int

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

extension MyProfileDTO {
    func toDomain() -> MyProfile {
        return MyProfile(
            id: id,
            status: status,
            nickName: nickName,
            profileImageURL: profileImageURL,
            email: email,
            registeredDate: registeredDate,
            tipCount: tipCount,
            savedTipCount: savedTipCount,
            subscriberCount: subscriberCount
        )
    }
}
