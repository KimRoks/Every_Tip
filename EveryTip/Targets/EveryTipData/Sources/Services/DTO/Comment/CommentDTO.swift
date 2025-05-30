//
//  CommentDTO.swift
//  EveryTipData
//
//  Created by 김경록 on 5/28/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import EveryTipDomain

import Foundation

public struct CommentDTO: Codable {
    let code: String
    let message: String
    let data: Data

    struct Data: Codable {
        let isLogined: Bool
        let comments: [Comment]

        enum CodingKeys: String, CodingKey {
            case isLogined = "is_logined"
            case comments
        }
    }

    struct Comment: Codable {
        let id: Int
        let parentID: Int?
        let content: String
        let createdAt: String
        let writer: Writer
        let likes: Int
        let replies: [Comment]
        let isMine: Bool
        let isLiked: Bool

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

        struct Writer: Codable {
            let id: Int
            let name: String
            let profileImage: String?
            
            enum CodingKeys: String, CodingKey {
                case id
                case name
                case profileImage = "profile_image"
            }
        }
    }
}

extension CommentDTO.Comment {
    func toDomain() -> Comment {
        return Comment(
            id: id,
            parentID: parentID,
            content: content,
            createdAt: createdAt,
            writer: .init(
                id: writer.id,
                name: writer.name,
                profileImage: writer.profileImage
            ),
            likes: likes,
            replies: replies.map { $0.toDomain() },
            isMine: isMine,
            isLiked: isLiked
        )
    }
}
