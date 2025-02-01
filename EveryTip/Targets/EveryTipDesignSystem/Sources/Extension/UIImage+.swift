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
        }
    }
}
