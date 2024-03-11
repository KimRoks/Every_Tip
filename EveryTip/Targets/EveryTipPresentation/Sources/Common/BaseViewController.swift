//
//  BaseViewController.swift
//  EveryTip
//
//  Created by 손대홍 on 1/20/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    /// 스와이프로 뒤로가기 활성화 여부
    var isInteractivePopGestureEnabled = false
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isInteractivePopGestureEnabled {
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // MARK: - Methods
    
    func setupViews() {
        view.backgroundColor = .white
    }
}
