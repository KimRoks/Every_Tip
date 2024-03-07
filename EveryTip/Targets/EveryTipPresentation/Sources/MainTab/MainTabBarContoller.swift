//
//  MainTabBarContoller.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/14/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class MainTabBarContoller: UITabBarController {
    
    private let buttonShadowSize: CGSize = CGSize(width: 1, height: 3)
    private let tabBarShadowSize: CGSize = CGSize(width: 0, height: -2)
    
    private lazy var middleButton: UIButton = {
        let button = UIButton(type: .system)
        // TODO: 이미지 에셋 받으면 변경
        
        button.setBackgroundImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = UIColor.EveryTip.BrandColor1
        button.tintColor = .white
        button.layer.cornerRadius = 25
        
        button.addShadow(
            offset: buttonShadowSize,
            opacity: 0.2,
            radius: 4
        )
        
        button.addTarget(nil, action: #selector(presentPost), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMainTabBarController()
    }
    
    private func configureMainTabBarController() {
        tabBar.addSubview(middleButton)
        middleButton.frame = CGRect(
            x: tabBar.frame.width / 2 - 25,
            y: -10,
            width: 50,
            height: 50
        )
        
        let firstViewController = BaseViewController()
        let secondViewController = UIViewController()
        //중앙 공백 아이템 추가 및 비활성화
        let emptyVC = UIViewController()
        emptyVC.tabBarItem.isEnabled = false
        
        let thirdViewContoller = UIViewController()
        let fouthViewController = UIViewController()
        
        firstViewController.view.backgroundColor = .red.withAlphaComponent(0.8)
        secondViewController.view.backgroundColor = .blue.withAlphaComponent(0.8)
        thirdViewContoller.view.backgroundColor = .green.withAlphaComponent(0.8)
        fouthViewController.view.backgroundColor = .white.withAlphaComponent(0.8)
        
        setViewControllers(
            [firstViewController,
             secondViewController,
             emptyVC,
             thirdViewContoller,
             fouthViewController],
            animated: true
        )
        
        tabBar.tintColor = .black.withAlphaComponent(0.8)
        tabBar.backgroundColor = UIColor(
            red: 0.95,
            green: 0.95,
            blue: 0.95,
            alpha: 1.00
        )
        
        // TODO: 이미지 에셋 받으면 변경
        tabBar.items?[0].image = UIImage(systemName: "house.fill")
        tabBar.items?[0].title = "홈"
        
        tabBar.items?[1].image = UIImage(systemName: "menucard")
        tabBar.items?[1].title = "카테고리"
        
        tabBar.items?[3].image = UIImage(systemName: "sidebar.squares.right")
        tabBar.items?[3].title = "탐색"
        
        tabBar.items?[4].image = UIImage(systemName: "person.fill")
        tabBar.items?[4].title = "내정보"
        
        tabBar.layer.masksToBounds = false
        
        tabBar.addShadow(
            offset: tabBarShadowSize,
            opacity: 0.12,
            radius: 5
        )
    }
    
    @objc
    func presentPost() {
        let postViewContoller = PostTipViewController()
        postViewContoller.modalPresentationStyle = .fullScreen
        self.present(postViewContoller, animated: true)
    }
}
