//
//  UserPreviewDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 7/2/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

struct UserPreviewDTO: Decodable {
    let code: String
    let message: String
    let data: [UserData]

    struct UserData: Decodable {
        let id: Int
        let nickName: String
        let profileImage: String?

        enum CodingKeys: String, CodingKey {
            case id
            case nickName = "nick_name"
            case profileImage = "profile_image"
        }

        func toDomain() -> UserPreview {
            return UserPreview(
                id: id,
                nickName: nickName,
                profileImageURL: profileImage
            )
        }
    }

    func toDomain() -> [UserPreview] {
        return data.map { $0.toDomain() }
    }
}
