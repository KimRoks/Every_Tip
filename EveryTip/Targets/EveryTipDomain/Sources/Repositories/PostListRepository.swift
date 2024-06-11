//
//  PostListModel.swift
//  EveryTipDomain
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import RxSwift

public struct PostListModel: Decodable {
    
    public init(
        category: String,
        title: String,
        mainText: String,
        thumbnailImageURL: String,
        userName: String,
        viewCount: Int,
        likeCount: Int
    ) {
        self.category = category
        self.title = title
        self.mainText = mainText
        self.thumbnailImageURL = thumbnailImageURL
        self.userName = userName
        self.viewCount = viewCount
        self.likeCount = likeCount
    }
    
    public let category: String
    public let title: String
    public let mainText: String
    public let thumbnailImageURL: String
    public let userName: String
    public let viewCount: Int
    public let likeCount: Int
}

public protocol PostRepository {
    func fetchPost() -> Single<[PostListModel]>
}
