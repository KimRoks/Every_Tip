//
//  TipDTO.swift
//  EveryTipDomain
//
//  Created by 김경록 on 5/19/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

public struct TipDTO: Codable {
    public let code: String
    public let message: String
    public let data: TipData

    public init(code: String, message: String, data: TipData) {
        self.code = code
        self.message = message
        self.data = data
    }

    public struct TipData: Codable {
        public let isLogined: Bool
        public let tips: [Tip]

        enum CodingKeys: String, CodingKey {
            case isLogined = "is_logined"
            case tips
        }

        public init(isLogined: Bool, tips: [Tip]) {
            self.isLogined = isLogined
            self.tips = tips
        }

        public struct Tip: Codable {
            public let id: Int
            public let title: String
            public let content: String
            public let categoryName: String
            public let categoryId: Int
            public let views: Int
            public let createdAt: String
            public let tags: [String]
            public let images: [Image]?
            public let writer: Writer
            public let likes: Int
            public let commentsCount: Int
            public let isMine: Bool
            public let isLiked: Bool
            public let isSaved: Bool

            enum CodingKeys: String, CodingKey {
                case id, title, content, views, tags, writer, likes
                case categoryName = "category_name"
                case categoryId = "category_id"
                case createdAt = "created_at"
                case images
                case commentsCount = "comments_count"
                case isMine = "is_mine"
                case isLiked = "is_liked"
                case isSaved = "is_saved"
            }

            public init(
                id: Int,
                title: String,
                content: String,
                categoryName: String,
                categoryId: Int,
                views: Int,
                createdAt: String,
                tags: [String],
                images: [Image]?,
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

            public struct Image: Codable {
                public let url: String
                public let isThumbnail: Int

                enum CodingKeys: String, CodingKey {
                    case url
                    case isThumbnail = "is_thumbnail"
                }

                public init(url: String, isThumbnail: Int) {
                    self.url = url
                    self.isThumbnail = isThumbnail
                }
            }

            public struct Writer: Codable {
                public let id: Int
                public let name: String
                public let profileImage: String?

                enum CodingKeys: String, CodingKey {
                    case id, name
                    case profileImage = "profile_image"
                }

                public init(id: Int, name: String, profileImage: String?) {
                    self.id = id
                    self.name = name
                    self.profileImage = profileImage
                }
            }
        }
    }
}

// MARK: - Domain Mapping

public extension TipDTO.TipData.Tip {
    func toDomain() -> Tip {
        return Tip(
            id: id,
            title: title,
            content: content,
            categoryName: categoryName,
            categoryId: categoryId,
            views: views,
            createdAt: createdAt,
            tags: tags,
            images: images?.map { $0.toDomain() } ?? [],
            writer: writer.toDomain(),
            likes: likes,
            commentsCount: commentsCount,
            isMine: isMine,
            isLiked: isLiked,
            isSaved: isSaved
        )
    }
}

public extension TipDTO.TipData.Tip.Image {
    func toDomain() -> Tip.Image {
        return Tip.Image(
            url: url,
            isThumbnail: isThumbnail
        )
    }
}

public extension TipDTO.TipData.Tip.Writer {
    func toDomain() -> Tip.Writer {
        return Tip.Writer(
            id: id,
            name: name,
            profileImage: profileImage
        )
    }
}
