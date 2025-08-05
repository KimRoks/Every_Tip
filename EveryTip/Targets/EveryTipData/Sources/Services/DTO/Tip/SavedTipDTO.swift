//
//  SavedTipDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 6/29/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation
import EveryTipDomain

public struct SavedTipDTO: Codable {
    public let code: String
    public let message: String
    public let data: [Tip]

    public struct Tip: Codable {
        public let id: Int
        public let title: String
        public let content: String
        public let categoryName: String
        public let categoryId: Int
        public let views: Int
        public let createdAt: String
        public let images: [Image]?
        public let writer: Writer
        public let likes: Int
        public let commentsCount: Int

        enum CodingKeys: String, CodingKey {
            case id, title, content, views, writer, likes
            case categoryName = "category_name"
            case categoryId = "category_id"
            case createdAt = "created_at"
            case images
            case commentsCount = "comments_count"
        }

        public struct Image: Codable {
            public let url: String
            public let isThumbnail: Int

            enum CodingKeys: String, CodingKey {
                case url
                case isThumbnail = "is_thumbnail"
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
        }
    }
}
public extension SavedTipDTO.Tip {
    func toDomain() -> Tip {
        return Tip(
            id: id,
            title: title,
            content: content,
            categoryName: categoryName,
            categoryId: categoryId,
            views: views,
            createdAt: createdAt,
            tags: [], // JSON에 tags 없음
            images: images?.map { $0.toDomain() } ?? [],
            writer: writer.toDomain(),
            likes: likes,
            commentsCount: commentsCount,
            isMine: false,  // JSON에 없음
            isLiked: false, // JSON에 없음
            isSaved: true   // 저장된 팁 목록이므로 true로 고정
        )
    }
}

public extension SavedTipDTO.Tip.Image {
    func toDomain() -> Tip.Image {
        return Tip.Image(
            url: url,
            isThumbnail: isThumbnail
        )
    }
}

public extension SavedTipDTO.Tip.Writer {
    func toDomain() -> Tip.Writer {
        return Tip.Writer(
            id: id,
            name: name,
            profileImage: profileImage
        )
    }
}
