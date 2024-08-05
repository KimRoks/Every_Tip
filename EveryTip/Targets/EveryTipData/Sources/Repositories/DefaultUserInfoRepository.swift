//
//  DefaultUserInfoRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 8/3/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import RxSwift

final class DefaultUserInfoRepository: UserInfoRepository {
    func getInfoTableViewItems() -> [String] {
        Constants.Presentation.TableViewItems.infoTableViewItems
    }
    
    // TODO: dummy Data -> api를 통한 실질적 Data

    private let dummyData: User = User(
        userName: "꼬견주",
        profileImage: "https://example.com/profile.jpg",
        userStatistics: UserStatistics(
            id: "biz123456",
            subscribersCount: 123,
            postedTipCount: 456,
            savedTipCount: 452,
            postedTip: PostedTip(postedTip:[
                Tip(
                    category: "Health",
                    title: "Stay Hydrated",
                    mainText: "Drink at least 8 glasses of water every day.",
                    thumbnailImageURL: "https://example.com/tip1.jpg",
                    userName: "꼬견주",
                    viewCount: 150,
                    likeCount: 35
                ),
                Tip(
                    category: "Fitness",
                    title: "Morning Yoga",
                    mainText: "Start your day with 20 minutes of yoga.",
                    thumbnailImageURL: "https://example.com/tip2.jpg",
                    userName: "꼬견주",
                    viewCount: 120,
                    likeCount: 40
                )
            ])
            ,
            savedTip: SavedTip(savedTip: [Tip(
                category: "Diet",
                title: "Healthy Breakfast",
                mainText: "Have a balanced breakfast with protein and fruits.",
                thumbnailImageURL: "https://example.com/tip3.jpg",
                userName: "Jane_Doe",
                viewCount: 100,
                likeCount: 50
            )
            ])
        )
    )
    
    func fetchUserInfo() -> Single<User> {
        return Single<User>.just(dummyData)
    }
}
