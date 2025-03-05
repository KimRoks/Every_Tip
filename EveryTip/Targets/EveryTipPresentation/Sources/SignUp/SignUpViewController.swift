//
//  SignUpViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 2/12/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem
import EveryTipDomain

import SnapKit
import RxSwift
import ReactorKit

final class SignUpViewController: BaseViewController {
    
    weak var coordinator: SignUpCoordinator?
    
    var disposeBag = DisposeBag()

    private let titleView: TitleDescriptionView = {
        let view = TitleDescriptionView(
            title: "회원가입",
            subTitle: "회원 여부 확인 및 가입을 진행합니다"
        )
        
        view.backgroundColor = .blue
        
        return view
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "아이디(이메일)"
        label.font = .et_pretendard(style: .medium, size: 16)
        
        return label
    }()
    
    private let emailTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: true,
            textFieldRightInset: 90
        )
        
        etView.textField.placeholder = "예) everytip@everytip.com"
        etView.textField.keyboardType = .emailAddress
        etView.textField.autocapitalizationType = .none
        
        return etView
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.titleLabel?.font = .et_pretendard(
            style: .bold,
            size: 14
        )
        button.tintColor = .et_brandColor2
        button.backgroundColor = .et_brandColor2.withAlphaComponent(0.15)
        button.layer.cornerRadius = 6
        button.setTitle("인증하기", for: .normal)
        
        return button
    }()
    
    private let verificationCodeTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: false,
            textFieldRightInset: 90
        )
        etView.textField.keyboardType = .numberPad
        etView.textField.placeholder = "인증번호 4자리 입력"
        etView.textField.autocapitalizationType = .none
        
        return etView
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .et_brandColor2
        label.isHidden = true
        
        return label
    }()
    
    private let verificationCompletedLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .et_textColor5
        label.textColor = .et_lineGray20
        label.text = "✓ 인증완료"
        label.font = .et_pretendard(
            style: .bold,
            size: 14
        )
        label.textAlignment = .center
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private let separator: StraightLineView = {
        let line = StraightLineView(color: .et_lineGray20)
        
        return line
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        return label
    }()
    
    private let passwordTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: true,
            hasSecureTextButton: true,
            textFieldRightInset: 16
        )
        
        etView.textField.placeholder = "비밀번호 입력 (영문+숫자 조합 8자리 이상)"
        etView.textField.keyboardType = .asciiCapable
        etView.textField.autocapitalizationType = .none
        return etView
    }()
    
    private let confirmPasswordTextFieldView: EveryTipTextFieldView = {
        let etView = EveryTipTextFieldView(
            hasClearButton: true,
            hasSecureTextButton: true,
            textFieldRightInset: 16
        )
        etView.textField.placeholder = "비밀번호 확인 입력"
        etView.textField.keyboardType = .asciiCapable
        etView.textField.autocapitalizationType = .none
        
        return etView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.isEnabled = false
        button.backgroundColor = .et_textColor5
        button.tintColor = .white
        button.titleLabel?.font = .et_pretendard(style: .bold, size: 18)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    init(reactor: SignUpReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        
        // TODO: 커스텀 네비게이션으로 대체
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupLayout() {
        view.addSubViews(
            titleView,
            emailLabel,
            emailTextFieldView,
            verificationCodeTextFieldView,
            timerLabel,
            separator,
            passwordLabel,
            passwordTextFieldView,
            confirmPasswordTextFieldView,
            submitButton,
            verificationCompletedLabel
        )
        
        view.addSubview(verifyButton)
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        verifyButton.snp.makeConstraints {
            $0.width.equalTo(74)
            $0.height.equalTo(36)
            $0.centerY.equalTo(emailTextFieldView.textField.snp.centerY)
            $0.trailing.equalTo(emailTextFieldView.snp.trailing).offset(-8)
        }
        
        verificationCodeTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        verificationCompletedLabel.snp.makeConstraints {
            $0.width.equalTo(verificationCodeTextFieldView.textField.snp.width).multipliedBy(0.36)
            $0.height.equalTo(verificationCodeTextFieldView.textField.snp.height).multipliedBy(0.69)
            $0.centerY.equalTo(verificationCodeTextFieldView.textField.snp.centerY)
            $0.trailing.equalTo(verificationCodeTextFieldView.snp.trailing).offset(-9)
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerY.equalTo(verificationCodeTextFieldView.textField.snp.centerY)
            $0.trailing.equalTo(verificationCodeTextFieldView.snp.trailing).offset(-26)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(verificationCodeTextFieldView.snp.bottom).offset(32)
            $0.leading.trailing.equalTo(view)
            $0.height.equalTo(8)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(separator.snp.bottom).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        confirmPasswordTextFieldView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(passwordTextFieldView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        
        submitButton.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
