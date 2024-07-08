//
//  MainTabBarContoller.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/14/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

final class MainTabBarContoller: UITabBarController {
    
    //MARK: Properties
    
    weak var coordinator: MainTabCoordinator?
    
    //MARK: Navigation Items
    
    private let titleLogoLabel: UILabel = {
        let label = UILabel()
        label.text = "every tip"
        label.textColor = .white
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 20
        )
        
        return label
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        button.setImage(UIImage(
            systemName: "magnifyingglass",
            withConfiguration: boldConfig
        ), for: .normal
        )
        button.tintColor = .white
        
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        let boldConfig = UIImage.SymbolConfiguration(weight: .bold)
        button.setImage(UIImage(
            systemName: "bell",
            withConfiguration: boldConfig
        ), for: .normal
        )
        button.tintColor = .white
        
        return button
    }()
    
    //MARK: Tabbar Middle Button
    
    private let buttonShadowSize: CGSize = CGSize(
        width: 1,
        height: 3
    )
    
    private let tabBarShadowSize: CGSize = CGSize(
        width: 0,
        height: -2
    )
    
    private lazy var middleButton: UIButton = {
        let button = UIButton(type: .system)
        // TODO: 이미지 에셋 받으면 변경
        
        button.setBackgroundImage(
            UIImage(systemName: "plus"),
            for: .normal
        )
        button.backgroundColor = .et_brandColor1
        button.tintColor = .white
        button.layer.cornerRadius = 25
        
        button.addShadow(
            offset: buttonShadowSize,
            opacity: 0.2,
            radius: 4
        )
        
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
        setupNavigationBar()
    }
    
    //MARK: Internal Methods
    
    func configureMainTabBarController() {
        tabBar.addSubview(middleButton)
        middleButton.frame = CGRect(
            x: tabBar.frame.width / 2 - 25,
            y: -10,
            width: 50,
            height: 50
        )
        
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
            (viewControllers[0], "house.fill", "홈"),
            (viewControllers[1], "menucard", "카테고리"),
            (viewControllers[3], "sidebar.squares.right", "탐색"),
            (viewControllers[4], "person.fill", "내정보")
        ]
        
        for (_, (vc, imageName, title)) in tabBarItems.enumerated() {
            vc.tabBarItem.image = UIImage(systemName: imageName)
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
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLogoLabel)
        
        let stackView = UIStackView(arrangedSubviews: [searchButton, notificationButton])
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
}
