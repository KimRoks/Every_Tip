//
//  UserContentsViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/18/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

// TODO: 이 뷰는 아예 미완성임
final class UserContentsViewController: BaseViewController {
    
    weak var coordinator: UserContentsCoordinator?
    
    private let topTabBar: UIView = {
        let view = UIView()
        
        return view
    }()
    
    let subscriberButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("구독자", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .bold,
            size: 16
        )
        
        return button
    }()
    
    let writtenTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("작성 팁", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .bold,
            size: 16
        )
        
        return button
    }()
    
    let savedTipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장 팁", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .bold,
            size: 16
        )
        
        return button
    }()
    
    private let subscribeListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
}
