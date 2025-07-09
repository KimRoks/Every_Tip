//
//  UserPreView.swift
//  EveryTipDomain
//
//  Created by 김경록 on 7/2/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct UserPreview {
    public let id: Int
    public let nickName: String
    public let profileImageURL: String?
    
    public init(
        id: Int,
        nickName: String,
        profileImageURL: String?
    ) {
        self.id = id
        self.nickName = nickName
        self.profileImageURL = profileImageURL
    }
}
