//
//  Tip.swift
//  EveryTipDomain
//
//  Created by 김경록 on 6/14/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

public struct Tip {
    public let id: Int
    public let title: String
    public let content: String
    public let categoryName: String
    public let categoryId: Int
    public let views: Int
    public let createdAt: String
    public let tags: [String]
    public let images: [Image]
    public let writer: Writer
    public let likes: Int
    public let commentsCount: Int
    public let isMine: Bool
    public let isLiked: Bool
    public let isSaved: Bool

    public init(
        id: Int,
        title: String,
        content: String,
        categoryName: String,
        categoryId: Int,
        views: Int,
        createdAt: String,
        tags: [String],
        images: [Image],
        writer: Writer,
        likes: Int,
        commentsCount: Int,
        isMine: Bool,
        isLiked: Bool,
        isSaved: Bool
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.categoryName = categoryName
        self.categoryId = categoryId
        self.views = views
        self.createdAt = createdAt
        self.tags = tags
        self.images = images
        self.writer = writer
        self.likes = likes
        self.commentsCount = commentsCount
        self.isMine = isMine
        self.isLiked = isLiked
        self.isSaved = isSaved
    }

    public struct Image {
        public let url: String
        public let isThumbnail: Int

        public init(url: String, isThumbnail: Int) {
            self.url = url
            self.isThumbnail = isThumbnail
        }
    }

    public struct Writer {
        public let id: Int
        public let name: String
        public let profileImage: String?

        public init(id: Int, name: String, profileImage: String?) {
            self.id = id
            self.name = name
            self.profileImage = profileImage
        }
    }
}
