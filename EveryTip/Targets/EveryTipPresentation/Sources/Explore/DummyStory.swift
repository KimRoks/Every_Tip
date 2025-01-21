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
}

struct DummyStory {
    var user: DummyUser
    var userName: String
    var userProfileIamge: UIImage
}

final class DefaultDummyStory: DummyStoryUseCase {
    let dummy = [
           DummyStory(user: DummyUser(userID: 1), userName: "강백호", userProfileIamge: .add),
           DummyStory(user: DummyUser(userID: 2), userName: "서태웅", userProfileIamge: .remove),
           DummyStory(user: DummyUser(userID: 3), userName: "채치수", userProfileIamge: .actions),
           DummyStory(user: DummyUser(userID: 4), userName: "정대만", userProfileIamge: .strokedCheckmark),
           DummyStory(user: DummyUser(userID: 5), userName: "송태섭", userProfileIamge: .remove),
           DummyStory(user: DummyUser(userID: 6), userName: "권준호", userProfileIamge: .add),
           DummyStory(user: DummyUser(userID: 7), userName: "이달재", userProfileIamge: .remove),
           DummyStory(user: DummyUser(userID: 8), userName: "신오일", userProfileIamge: .actions),
           DummyStory(user: DummyUser(userID: 9), userName: "채소연", userProfileIamge: .strokedCheckmark),
           DummyStory(user: DummyUser(userID: 10), userName: "이한나", userProfileIamge: .remove),
           DummyStory(user: DummyUser(userID: 11), userName: "윤대협", userProfileIamge: .add),
           DummyStory(user: DummyUser(userID: 12), userName: "변덕규", userProfileIamge: .remove),
           DummyStory(user: DummyUser(userID: 13), userName: "황태산", userProfileIamge: .actions),
           DummyStory(user: DummyUser(userID: 14), userName: "허태환", userProfileIamge: .strokedCheckmark),
           DummyStory(user: DummyUser(userID: 15), userName: "안영수", userProfileIamge: .remove)
       ]
    
    func getDummy() -> Single<[DummyStory]> {
        return Single.just(dummy)
    }
}
