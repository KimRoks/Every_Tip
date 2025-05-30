//
//  Comment.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/27/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

public struct Comment {
    public let id: Int
    public let parentID: Int?
    public let content: String
    public let createdAt: String
    public let writer: Writer
    public let likes: Int
    public let replies: [Comment]
    public let isMine: Bool
    public let isLiked: Bool
    
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
    }
}
