//
//  SignupSuccessViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/28/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain
import SnapKit

final class SignupSuccessViewController: BaseViewController {
    
    weak var coordinator: SignupSuccessCoordinator?
    
    private let completedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .et_getImage(for: .signupCompleted)
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가입이 완료되었습니다."
        label.font = .et_pretendard(
            style: .semiBold,
            size: 24
        )
        label.textColor = .black
        
        return label
    }()
    
    private let subTitleLable: UILabel = {
        let label = UILabel()
        label.text = "지금 바로 에브리팁을 이용해보세요!"
        label.font = .et_pretendard(
            style: .regular,
            size: 16
        )
        label.textColor = .et_textColorBlack10
        
        return label
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("홈 이동", for: .normal)
        button.titleLabel?.font = .et_pretendard(
            style: .bold,
            size: 16
        )
        
        button.backgroundColor = .et_brandColor2
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        // 유저가 회원가입 후 비정상 루트로 이동하지 못하게 하기 위함
        self.navigationController?.isNavigationBarHidden = true
        confirmButton.addTarget(
            self,
            action: #selector(popToFirst),
            for: .touchUpInside
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animatePulse()
    }
    
    private func animatePulse() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: [
                .repeat,
                .autoreverse,
                .allowUserInteraction
            ]) {
                self.completedImageView.transform = CGAffineTransform(
                    scaleX: 1.1,
                    y: 1.1
                )
            }
    }
    
    private func setupLayout() {
        view.addSubViews(
            completedImageView,
            titleLabel,
            subTitleLable,
            confirmButton
        )
    }
    
    private func setupConstraints() {
        completedImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(170)
            $0.centerX.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(completedImageView.snp.bottom).offset(32)
            $0.centerX.equalTo(view)
        }
        
        subTitleLable.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalTo(view)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(56)
        }
    }
    
    @objc
    private func popToFirst() {
        self.navigationController?.isNavigationBarHidden = false
        self.coordinator?.popToRootView()
    }
}
