//
//  User.swift
//  EveryTipDomain
//
//  Created by 김경록 on 8/3/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct User: Decodable {
    public init(
        userName: String,
        profileImage: String,
        userStatistics: UserStatistics
    ) {
        self.userName = userName
        self.profileImage = profileImage
        self.userStatistics = userStatistics
    }
    
    public let userName: String
    public let profileImage: String
    public let userStatistics: UserStatistics
}

public struct UserStatistics: Decodable {
    
    public init(
        id: String,
        subscribersCount: Int,
        postedTipCount: Int,
        savedTipCount: Int,
        postedTip: PostedTip,
        savedTip: SavedTip
    ) {
        self.id = id
        self.subscribersCount = subscribersCount
        self.postedTipCount = postedTipCount
        self.savedTipCount = savedTipCount
        self.postedTip = postedTip
        self.savedTip = savedTip
    }
    
    public let id: String
    public let subscribersCount: Int
    public let postedTipCount: Int
    public let savedTipCount: Int
    
    public let postedTip: PostedTip
    public let savedTip: SavedTip
}

public struct PostedTip: Decodable {
    public init(postedTip: [Tip]) {
        self.postedTip = postedTip
    }
    public let postedTip: [Tip]
}

public struct SavedTip: Decodable {
    public init(savedTip: [Tip]) {
        self.savedTip = savedTip
    }
    let savedTip: [Tip]
}
