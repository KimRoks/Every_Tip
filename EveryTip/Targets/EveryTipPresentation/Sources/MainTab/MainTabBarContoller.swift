//
//  MainTabBarContoller.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/14/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit

final class MainTabBarContoller: UITabBarController {
    
    //MARK: Properties
    
    weak var coordinator: MainTabCoordinator?
    
    //MARK: Tabbar Middle Button
    
    private let buttonShadowSize: CGSize = CGSize(
        width: 1,
        height: 3
    )
    
    private let tabBarShadowSize: CGSize = CGSize(
        width: 0,
        height: -2
    )
    
    private let addTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(.et_getImage(for: .add_Tip), for: .normal)
        button.addTarget(
            nil,
            action: #selector(presentPostView),
            for: .touchUpInside
        )
        
        return button
    }()
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Internal Methods
    
    func configureMainTabBarController() {
        tabBar.addSubview(addTipButton)
    
        addTipButton.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(82)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(tabBar.snp.centerY).offset(-17)
        }
    
        tabBar.tintColor = .black.withAlphaComponent(0.8)
        tabBar.backgroundColor = UIColor(
            red: 0.95,
            green: 0.95,
            blue: 0.95,
            alpha: 1.00
        )
        
        guard let viewControllers = viewControllers else {
            return
        }
        
        let tabBarItems = [
            (viewControllers[0], ImageAssetType.mainTab_Home, "홈"),
            (viewControllers[1], ImageAssetType.mainTab_Category, "카테고리"),
            (viewControllers[3], ImageAssetType.mainTab_Discovery, "탐색"),
            (viewControllers[4], ImageAssetType.mainTab_MyInfo, "내정보")
        ]
        
        for (_, (vc, imageType, title)) in tabBarItems.enumerated() {
            vc.tabBarItem.image = UIImage.et_getImage(for: imageType)
           
            vc.tabBarItem.title = title
        }
        
        tabBar.layer.masksToBounds = false
        
        tabBar.addShadow(
            offset: tabBarShadowSize,
            opacity: 0.12,
            radius: 5
        )
    }
    
    //MARK: Private Methods
    
    @objc
    private func presentPostView() {
        coordinator?.presentPostView()
    }
}
