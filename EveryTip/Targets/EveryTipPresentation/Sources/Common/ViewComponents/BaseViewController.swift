//
//  BaseViewController.swift
//  EveryTip
//
//  Created by 손대홍 on 1/20/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, ToastDisplayable {
    /// 스와이프로 뒤로가기 활성화 여부
    var isInteractivePopGestureEnabled = false
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupKeyboardDismissGesture()
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
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
