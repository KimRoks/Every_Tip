//
//  DummyStory.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/15/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit
import RxSwift

protocol DummyStoryUseCase {
    func getDummy() -> Single<[DummyStory]>
}

struct DummyUser {
    var userID: Int
    var userName: String
    var userProfileImage: UIImage
}

enum DummyType {
    case user
    case everyTip
}

struct DummyStory {
    var type: DummyType
    var userData: DummyUser?
}

final class DefaultDummyStory: DummyStoryUseCase {
    let dummy = [
            DummyStory(type: .user, userData: DummyUser(userID: 1, userName: "강백호", userProfileImage: .add)),
            DummyStory(type: .user, userData: DummyUser(userID: 2, userName: "서태웅", userProfileImage: .remove)),
            DummyStory(type: .user, userData: DummyUser(userID: 3, userName: "채치수", userProfileImage: .actions)),
            DummyStory(type: .user, userData: DummyUser(userID: 4, userName: "정대만", userProfileImage: .strokedCheckmark)),
            DummyStory(type: .user, userData: DummyUser(userID: 5, userName: "송태섭", userProfileImage: .remove)),
            DummyStory(type: .user, userData: DummyUser(userID: 6, userName: "권준호", userProfileImage: .add)),
            DummyStory(type: .user, userData: DummyUser(userID: 7, userName: "이달재", userProfileImage: .remove)),
            DummyStory(type: .user, userData: DummyUser(userID: 8, userName: "신오일", userProfileImage: .actions)),
            DummyStory(type: .user, userData: DummyUser(userID: 9, userName: "채소연", userProfileImage: .strokedCheckmark)),
            DummyStory(type: .user, userData: DummyUser(userID: 10, userName: "이한나", userProfileImage: .remove)),
            DummyStory(type: .user, userData: DummyUser(userID: 11, userName: "윤대협", userProfileImage: .add)),
            DummyStory(type: .user, userData: DummyUser(userID: 12, userName: "변덕규", userProfileImage: .remove)),
            DummyStory(type: .user, userData: DummyUser(userID: 13, userName: "황태산", userProfileImage: .actions)),
            DummyStory(type: .user, userData: DummyUser(userID: 14, userName: "허태환", userProfileImage: .strokedCheckmark)),
            DummyStory(type: .user, userData: DummyUser(userID: 15, userName: "안영수", userProfileImage: .remove))
        ]
    
    func getDummy() -> Single<[DummyStory]> {
        return Single.just(dummy)
    }
}
