//
//  DefaultPostListRepository.swift
//  EveryTipData
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import Foundation

import EveryTipDomain

import RxSwift

final class DefaultPostListRepository: PostRepository {
    
    // TODO: Mock Data -> api를 통한 실질적 Data
    let mockPosts: [Tip] = [
        Tip(
            category: "레시피",
            title: "아침 밥 맛있게 만드는 방법",
            mainText: "프랑스에서는 빵을 전혀 다른 요리로 만들었다는 뜻에서 프렌치토스트를 ‘잃어버린 빵’이라고 부른다고 해요. 달걀과 우유를 섞은 물에 퐁당 빠졌다가 나왔을 뿐인데 정말 색다른 맛으로 변신하지요. 바삭하게 구워내는 토스트도 좋지만, 폭신폭신하고 부드러운 프렌치토스트는 아침에 까끌까끌한 입을 달래준답니다. 노릇노릇 구워진 빵위에 달콤한 시럽과 과일을 곁들여 근사한 아침 식사를 만들어보세요.",
            thumbnailImageURL: "swift.png",
            userName: "JohnDoe",
            viewCount: 42,
            likeCount: 78
        ),
        Tip(
            category: "생활",
            title: "빨래할 때 유용한 팁",
            mainText: "빨래를 할 때 세탁망을 사용하면 옷감의 손상을 줄일 수 있습니다. 특히 얇은 옷이나 니트류는 세탁망에 넣어 세탁하는 것이 좋습니다. 또한, 세제를 너무 많이 사용하지 않는 것이 중요합니다. 세제가 많이 남으면 옷감에 손상을 줄 수 있으므로 적정량을 사용하는 것이 좋습니다. 마지막으로, 세탁 후에는 옷을 바로 건조기에 넣지 말고 바람이 잘 통하는 곳에서 자연 건조하는 것이 옷을 오래 입는 비결입니다.",
            thumbnailImageURL: "laundry.png",
            userName: "David",
            viewCount: 89,
            likeCount: 45
        ),
        Tip(
            category: "게임",
            title: "최고의 모바일 게임 추천",
            mainText: "요즘 모바일 게임 시장은 다양한 장르와 재미있는 게임들로 가득 차 있습니다. 그 중에서도 ‘쿠키런: 킹덤’은 전략과 RPG 요소가 결합된 게임으로, 다양한 캐릭터와 스토리가 매력적입니다. 또한 ‘리니지M’은 MMORPG 장르의 대표작으로, 방대한 세계와 커뮤니티 시스템이 특징입니다. 이 외에도 ‘브롤스타즈’, ‘펍지 모바일’ 등 다양한 게임들이 많은 인기를 끌고 있습니다.",
            thumbnailImageURL: "games.png",
            userName: "GameFan",
            viewCount: 65,
            likeCount: 99
        ),
        Tip(
            category: "스포츠",
            title: "축구 경기에서 승리하는 법",
            mainText: "축구 경기에서 승리하기 위해서는 팀워크가 가장 중요합니다. 각 포지션의 선수들이 자신의 역할을 충실히 수행하면서도 팀원들과의 협력을 통해 상대팀의 허점을 공략하는 것이 필요합니다. 또한, 체력 관리와 전략적인 플레이가 승패를 좌우합니다. 경기 전 충분한 스트레칭과 체력 단련을 통해 최상의 컨디션을 유지하고, 상황에 맞는 유연한 전략을 구사하는 것이 중요합니다.",
            thumbnailImageURL: "soccer.png",
            userName: "Sporty",
            viewCount: 77,
            likeCount: 53
        ),
        Tip(
            category: "사회",
            title: "효과적인 자원봉사 방법",
            mainText: "자원봉사는 단순히 시간을 보내는 것이 아니라, 자신이 가진 능력을 통해 다른 사람을 돕는 의미 있는 활동입니다. 자원봉사를 할 때에는 자신의 관심사와 능력에 맞는 봉사활동을 선택하는 것이 중요합니다. 예를 들어, 교육에 관심이 있다면 학습 멘토링을, 환경 보호에 관심이 있다면 쓰레기 줍기 활동을 선택할 수 있습니다. 이렇게 자신이 잘 할 수 있는 분야에서 봉사활동을 하면 더 큰 보람을 느낄 수 있습니다.",
            thumbnailImageURL: "volunteer.png",
            userName: "Helper",
            viewCount: 32,
            likeCount: 64
        ),
        Tip(
            category: "레시피",
            title: "아침 밥 맛있게 만드는 방법",
            mainText: "프랑스에서는 빵을 전혀 다른 요리로 만들었다는 뜻에서 프렌치토스트를 ‘잃어버린 빵’이라고 부른다고 해요. 달걀과 우유를 섞은 물에 퐁당 빠졌다가 나왔을 뿐인데 정말 색다른 맛으로 변신하지요. 바삭하게 구워내는 토스트도 좋지만, 폭신폭신하고 부드러운 프렌치토스트는 아침에 까끌까끌한 입을 달래준답니다. 노릇노릇 구워진 빵위에 달콤한 시럽과 과일을 곁들여 근사한 아침 식사를 만들어보세요.",
            thumbnailImageURL: "swift.png",
            userName: "JohnDoe",
            viewCount: 42,
            likeCount: 78
        ),
        Tip(
            category: "생활",
            title: "빨래할 때 유용한 팁",
            mainText: "빨래를 할 때 세탁망을 사용하면 옷감의 손상을 줄일 수 있습니다. 특히 얇은 옷이나 니트류는 세탁망에 넣어 세탁하는 것이 좋습니다. 또한, 세제를 너무 많이 사용하지 않는 것이 중요합니다. 세제가 많이 남으면 옷감에 손상을 줄 수 있으므로 적정량을 사용하는 것이 좋습니다. 마지막으로, 세탁 후에는 옷을 바로 건조기에 넣지 말고 바람이 잘 통하는 곳에서 자연 건조하는 것이 옷을 오래 입는 비결입니다.",
            thumbnailImageURL: "laundry.png",
            userName: "David",
            viewCount: 89,
            likeCount: 45
        ),
        Tip(
            category: "게임",
            title: "최고의 모바일 게임 추천",
            mainText: "요즘 모바일 게임 시장은 다양한 장르와 재미있는 게임들로 가득 차 있습니다. 그 중에서도 ‘쿠키런: 킹덤’은 전략과 RPG 요소가 결합된 게임으로, 다양한 캐릭터와 스토리가 매력적입니다. 또한 ‘리니지M’은 MMORPG 장르의 대표작으로, 방대한 세계와 커뮤니티 시스템이 특징입니다. 이 외에도 ‘브롤스타즈’, ‘펍지 모바일’ 등 다양한 게임들이 많은 인기를 끌고 있습니다.",
            thumbnailImageURL: "games.png",
            userName: "GameFan",
            viewCount: 65,
            likeCount: 99
        ),
        Tip(
            category: "스포츠",
            title: "축구 경기에서 승리하는 법",
            mainText: "축구 경기에서 승리하기 위해서는 팀워크가 가장 중요합니다. 각 포지션의 선수들이 자신의 역할을 충실히 수행하면서도 팀원들과의 협력을 통해 상대팀의 허점을 공략하는 것이 필요합니다. 또한, 체력 관리와 전략적인 플레이가 승패를 좌우합니다. 경기 전 충분한 스트레칭과 체력 단련을 통해 최상의 컨디션을 유지하고, 상황에 맞는 유연한 전략을 구사하는 것이 중요합니다.",
            thumbnailImageURL: "soccer.png",
            userName: "Sporty",
            viewCount: 77,
            likeCount: 53
        ),
        Tip(
            category: "사회",
            title: "효과적인 자원봉사 방법",
            mainText: "자원봉사는 단순히 시간을 보내는 것이 아니라, 자신이 가진 능력을 통해 다른 사람을 돕는 의미 있는 활동입니다. 자원봉사를 할 때에는 자신의 관심사와 능력에 맞는 봉사활동을 선택하는 것이 중요합니다. 예를 들어, 교육에 관심이 있다면 학습 멘토링을, 환경 보호에 관심이 있다면 쓰레기 줍기 활동을 선택할 수 있습니다. 이렇게 자신이 잘 할 수 있는 분야에서 봉사활동을 하면 더 큰 보람을 느낄 수 있습니다.",
            thumbnailImageURL: "volunteer.png",
            userName: "Helper",
            viewCount: 32,
            likeCount: 64
        ),
        Tip(
            category: "레시피",
            title: "아침 밥 맛있게 만드는 방법",
            mainText: "프랑스에서는 빵을 전혀 다른 요리로 만들었다는 뜻에서 프렌치토스트를 ‘잃어버린 빵’이라고 부른다고 해요. 달걀과 우유를 섞은 물에 퐁당 빠졌다가 나왔을 뿐인데 정말 색다른 맛으로 변신하지요. 바삭하게 구워내는 토스트도 좋지만, 폭신폭신하고 부드러운 프렌치토스트는 아침에 까끌까끌한 입을 달래준답니다. 노릇노릇 구워진 빵위에 달콤한 시럽과 과일을 곁들여 근사한 아침 식사를 만들어보세요.",
            thumbnailImageURL: "swift.png",
            userName: "JohnDoe",
            viewCount: 42,
            likeCount: 78
        ),
        Tip(
            category: "생활",
            title: "빨래할 때 유용한 팁",
            mainText: "빨래를 할 때 세탁망을 사용하면 옷감의 손상을 줄일 수 있습니다. 특히 얇은 옷이나 니트류는 세탁망에 넣어 세탁하는 것이 좋습니다. 또한, 세제를 너무 많이 사용하지 않는 것이 중요합니다. 세제가 많이 남으면 옷감에 손상을 줄 수 있으므로 적정량을 사용하는 것이 좋습니다. 마지막으로, 세탁 후에는 옷을 바로 건조기에 넣지 말고 바람이 잘 통하는 곳에서 자연 건조하는 것이 옷을 오래 입는 비결입니다.",
            thumbnailImageURL: "laundry.png",
            userName: "David",
            viewCount: 89,
            likeCount: 45
        ),
        Tip(
            category: "게임",
            title: "최고의 모바일 게임 추천",
            mainText: "요즘 모바일 게임 시장은 다양한 장르와 재미있는 게임들로 가득 차 있습니다. 그 중에서도 ‘쿠키런: 킹덤’은 전략과 RPG 요소가 결합된 게임으로, 다양한 캐릭터와 스토리가 매력적입니다. 또한 ‘리니지M’은 MMORPG 장르의 대표작으로, 방대한 세계와 커뮤니티 시스템이 특징입니다. 이 외에도 ‘브롤스타즈’, ‘펍지 모바일’ 등 다양한 게임들이 많은 인기를 끌고 있습니다.",
            thumbnailImageURL: "games.png",
            userName: "GameFan",
            viewCount: 65,
            likeCount: 99
        ),
        Tip(
            category: "스포츠",
            title: "축구 경기에서 승리하는 법",
            mainText: "축구 경기에서 승리하기 위해서는 팀워크가 가장 중요합니다. 각 포지션의 선수들이 자신의 역할을 충실히 수행하면서도 팀원들과의 협력을 통해 상대팀의 허점을 공략하는 것이 필요합니다. 또한, 체력 관리와 전략적인 플레이가 승패를 좌우합니다. 경기 전 충분한 스트레칭과 체력 단련을 통해 최상의 컨디션을 유지하고, 상황에 맞는 유연한 전략을 구사하는 것이 중요합니다.",
            thumbnailImageURL: "soccer.png",
            userName: "Sporty",
            viewCount: 77,
            likeCount: 53
        ),
        Tip(
            category: "사회",
            title: "효과적인 자원봉사 방법",
            mainText: "자원봉사는 단순히 시간을 보내는 것이 아니라, 자신이 가진 능력을 통해 다른 사람을 돕는 의미 있는 활동입니다. 자원봉사를 할 때에는 자신의 관심사와 능력에 맞는 봉사활동을 선택하는 것이 중요합니다. 예를 들어, 교육에 관심이 있다면 학습 멘토링을, 환경 보호에 관심이 있다면 쓰레기 줍기 활동을 선택할 수 있습니다. 이렇게 자신이 잘 할 수 있는 분야에서 봉사활동을 하면 더 큰 보람을 느낄 수 있습니다.",
            thumbnailImageURL: "volunteer.png",
            userName: "Helper",
            viewCount: 32,
            likeCount: 64
        ),
    ]
    
    func fetchPosts() -> Single<[Tip]> {
        return Single<[Tip]>.just(mockPosts)
    }
}
