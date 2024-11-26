//
//  UserContentsViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/18/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipCore

import SnapKit

// TODO: 이 뷰는 아예 미완성임
final class UserContentsViewController: BaseViewController {
    
    weak var coordinator: UserContentsCoordinator?
    
    private let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원만 쓸 수 있는 버튼", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
        setupLayout()
        setupConstraints()
        
        sendMessageButton.addTarget(
            nil,
            action: #selector(sendButtonTapped),
            for: .touchUpInside
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRefreshTokenExpired(_:)),
            name: .refreshTokenExpired,
            object: nil
        )
    }
    
    private func setupLayout() {
        view.addSubview(sendMessageButton)
    }
    
    private func setupConstraints() {
        sendMessageButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(100)
            $0.height.equalTo(70)
        }
    }
    
    @objc
    func sendButtonTapped() {
        let isLogined: Bool = TokenKeyChainManager.shared.isLogined
        if isLogined {
            postComment()
        } else {
            showAlertForLoginView()
        }
    }
    
    //인터셉터가 포함된, 회원여부가 필요한 작업입니다.
    func postComment() {
        print("회원만의 특혜를 누려.")
    }
    
    func showAlertForLoginView() {
        let alertCont = UIAlertController(title: "회원가입이 필요한 서비스입니다.", message: "회원가입을 위해 이동할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        ) {
            [weak self]_ in
            self?.coordinator?.pushToLoginView()
        }
        let cancelAction = UIAlertAction(title: "아뇨", style: .cancel)
        
        alertCont.addAction(okAction)
        alertCont.addAction(cancelAction)
        
        self.present(alertCont, animated: true)
        print("알럿: 회원만 이용 가능한데숑?")
    }
    
    @objc private func handleRefreshTokenExpired(_ notification: Notification) {
        if let error = notification.object as? Error {
            print("토큰 만료 에러: \(error.localizedDescription)")
        }
        showRefreshAlert()
    }
    
    private func showRefreshAlert() {
        let alertController = UIAlertController(
            title: "세션이 만료되어 재로그인이 필요합니다",
            message: "로그인을 위해 이동할까요?",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "확인",
            style: .default
        ) { [weak self] _ in
            self?.coordinator?.pushToLoginView()
        }
        let cancleAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(okAction)
        alertController.addAction(cancleAction)
        
        self.present(alertController, animated: true)
    }
}
