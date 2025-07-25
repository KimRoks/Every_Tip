//
//  UIImage+.swift
//  EveryTipDesignSystem
//
//  Created by 김경록 on 8/8/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

public enum ImageAssetType {
    case homeViewEmoji
    case categoryViewBanner
    case blankImage
    case everyTipLogoimage
    case likeImage_empty
    case likeImage_fill
    case viewsImage
    case commentImage
    case searchIcon
    case categoryIcon_hobby
    case categoryIcon_it
    case categoryIcon_health
    case categoryIcon_finance
    case categoryIcon_entertainment
    case categoryIcon_sports
    case categoryIcon_games
    case categoryIcon_social
    case everyTipLogo_story
    case add_Tip
    case mainTab_Home
    case mainTab_Category
    case mainTab_Discovery
    case mainTab_MyInfo
    case backButton
    case bell
    case bellOn
    case refresh
    case checkMark_circle
    case checkMark_normal
    case checkedMark_circle
    case checkedMark_normal
    case signupCompleted
    case addImage_empty
    case addImage_fill
    case nextButton
    case nextButton_darkGray
    case link
    case closeButton
    case edit
    case bookmark
    case bookmark_fill
    case share
    case reply
    case ellipsis
    case ellipsis_black
    case removePhoto
    case recent
    case placeholder
}

extension UIImage {
    public static func et_getImage(for imageAsset: ImageAssetType) -> UIImage {
        
        switch imageAsset {
        case .homeViewEmoji: EveryTipDesignSystemAsset.homeViewEmoji.image
        case .categoryViewBanner: EveryTipDesignSystemAsset.categoryViewBanner.image
        case .blankImage: EveryTipDesignSystemAsset.blankImage.image
        case .everyTipLogoimage: EveryTipDesignSystemAsset.everyTipLogo.image
        case .likeImage_empty:
            EveryTipDesignSystemAsset.likeImageEmpty.image
        case .likeImage_fill:
            EveryTipDesignSystemAsset.likeImageFill.image
        case .viewsImage:
            EveryTipDesignSystemAsset.viewsImage.image
        case .commentImage:
            EveryTipDesignSystemAsset.commentImage.image
        case .searchIcon:
            EveryTipDesignSystemAsset.searchIcon.image  
        case .categoryIcon_hobby:
            EveryTipDesignSystemAsset.categoryIconHobby.image
        case .categoryIcon_it:
            EveryTipDesignSystemAsset.categoryIconIt.image
        case .categoryIcon_health:
            EveryTipDesignSystemAsset.categoryIconHealth.image
        case .categoryIcon_finance:
            EveryTipDesignSystemAsset.categoryIconFinance.image
        case .categoryIcon_entertainment:
            EveryTipDesignSystemAsset.categoryIconEntertainment.image
        case .categoryIcon_sports:
            EveryTipDesignSystemAsset.categoryIconSports.image
        case .categoryIcon_games:
            EveryTipDesignSystemAsset.categoryIconGames.image
        case .categoryIcon_social:
            EveryTipDesignSystemAsset.categoryIconSocial.image
        case .everyTipLogo_story:
            EveryTipDesignSystemAsset.everyTipLogoStory.image
        case .add_Tip: EveryTipDesignSystemAsset.addTip.image
        case .mainTab_Home:
            EveryTipDesignSystemAsset.mainTabHome.image
        case .mainTab_Category:
            EveryTipDesignSystemAsset.mainTabCategory.image
        case .mainTab_Discovery:
            EveryTipDesignSystemAsset.mainTabDiscovery.image
        case .mainTab_MyInfo:
            EveryTipDesignSystemAsset.mainTabMyInfo.image
        case .backButton:
            EveryTipDesignSystemAsset.backButton.image
        case .bell:
            EveryTipDesignSystemAsset.bell.image
        case .bellOn:
            EveryTipDesignSystemAsset.bellOn.image
        case .refresh:
            EveryTipDesignSystemAsset.refresh.image
        case .checkMark_circle:
            EveryTipDesignSystemAsset.checkMarkCircle.image
        case .checkMark_normal:
            EveryTipDesignSystemAsset.checkMarkNormal.image
        case .checkedMark_circle:
            EveryTipDesignSystemAsset.checkedMarkCircle.image
        case .checkedMark_normal:
            EveryTipDesignSystemAsset.checkedMarkNormal.image
        case .signupCompleted:
            EveryTipDesignSystemAsset.signupCompleted.image
        case .addImage_empty:
            EveryTipDesignSystemAsset.addImageEmpty.image
        case .addImage_fill:
            EveryTipDesignSystemAsset.addImageFill.image
        case .nextButton:
            EveryTipDesignSystemAsset.nextButton.image
        case .nextButton_darkGray:
            EveryTipDesignSystemAsset.nextButtonDarkGray.image
        case .link:
            EveryTipDesignSystemAsset.link.image
        case .closeButton:
            EveryTipDesignSystemAsset.closeButton.image
        case .edit:
            EveryTipDesignSystemAsset.edit.image
        case .bookmark:
            EveryTipDesignSystemAsset.bookmark.image
        case .bookmark_fill:
            EveryTipDesignSystemAsset.bookmarkFill.image
        case .share:
            EveryTipDesignSystemAsset.share.image
        case .reply:
            EveryTipDesignSystemAsset.reply.image
        case .ellipsis:
            EveryTipDesignSystemAsset.ellipsis.image
        case .ellipsis_black:
            EveryTipDesignSystemAsset.ellipsisBlack.image
        case .removePhoto:
            EveryTipDesignSystemAsset.removePhoto.image
        case .recent:
            EveryTipDesignSystemAsset.recent.image
        case .placeholder:
            EveryTipDesignSystemAsset.placeholder.image
        }
    }
}
