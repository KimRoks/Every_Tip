//
//  Comment.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct Comment: Codable {
    public let id: Int
    public let parentID: Int?
    public let content: String
    public let createdAt: String
    public let writer: Writer
    public let likes: Int
    public let replies: [Comment]
    public let isMine: Bool
    public let isLiked: Bool
    
    // 디코딩 제외
    public var isReply: Bool = false
    
    public init(
        id: Int,
        parentID: Int?,
        content: String,
        createdAt: String,
        writer: Writer,
        likes: Int,
        replies: [Comment],
        isMine: Bool,
        isLiked: Bool
    ) {
        self.id = id
        self.parentID = parentID
        self.content = content
        self.createdAt = createdAt
        self.writer = writer
        self.likes = likes
        self.replies = replies
        self.isMine = isMine
        self.isLiked = isLiked
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case parentID = "parent_id"
        case content
        case createdAt = "created_at"
        case writer
        case likes
        case replies
        case isMine = "is_mine"
        case isLiked = "is_liked"
    }
    
    public struct Writer: Codable {
        public let id: Int
        public let name: String
        public let profileImage: String?
        
        public init(
            id: Int,
            name: String,
            profileImage: String?
        ) {
            self.id = id
            self.name = name
            self.profileImage = profileImage
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case profileImage = "profile_image"
        }
    }
}
