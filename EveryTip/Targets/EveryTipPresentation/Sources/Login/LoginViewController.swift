//
//  LoginViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 10/31/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import SnapKit
import ReactorKit
import RxSwift

import EveryTipDesignSystem

final class LoginViewController: BaseViewController {
    
    weak var coordinator: LoginCoordinator?
    
    var disposeBag = DisposeBag()
    
    private var activeTextField: UITextField?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.et_getImage(for: .everyTipLogoimage)
        
        return imageView
    }()
    
    private let slogunLabel: UILabel = {
        let label = UILabel()
        label.text = "세상의 모든 팁을 한 곳에, 에브리팁"
        label.font = UIFont.et_pretendard(style: .medium, size: 16)
        label.textAlignment = .center
        
        return label
    }()
    
    private let emailTextFieldView: EveryTipTextFieldView = {
        let textFiedldView = EveryTipTextFieldView(hasClearButton: true)
        let textField = textFiedldView.textField
        textField.keyboardType = .emailAddress
        textField.placeholder = "예) everyTip@everytip.com"
        
        return textFiedldView
    }()
    
    private let passwordTextFieldView: EveryTipTextFieldView = {
        let textFiedldView = EveryTipTextFieldView(hasClearButton: true, hasSecureTextButton: true)
        let textField = textFiedldView.textField
        
        textField.placeholder = "비밀번호 입력"
        
        return textFiedldView
    }()
    
    private let searchPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 찾기", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(style: .medium, size: 14)
        button.tintColor = .black
        
        return button
    }()
    
    private let separator: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.textColor = UIColor.et_textColorBlack10
        
        return label
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(style: .medium, size: 14)
        button.tintColor = .black
        
        return button
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.et_brandColor2
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        signupButton.addTarget(self, action: #selector(pushToSignUpView), for: .touchUpInside)
        setupTextFieldDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    init(reactor: LoginReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        coordinator?.didFinish()
    }
    
    private func setupLayout() {
        view.addSubViews(
            logoImageView,
            slogunLabel,
            emailTextFieldView,
            passwordTextFieldView,
            
            loginButton,
            searchPasswordButton,
            separator,
            signupButton
        )
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.centerX.equalTo(view.center.x)
            $0.width.equalTo(150)
            $0.height.equalTo(44)
        }
        
        slogunLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(slogunLabel.snp.bottom).offset(80)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        searchPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(8)
            $0.trailing.equalTo(separator.snp.leading).offset(-20)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(10)
            $0.centerX.equalTo(view.center.x)
        }
        
        signupButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(8)
            $0.leading.equalTo(separator.snp.trailing).offset(20)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(80)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(56)
        }
    }
    
    @objc
    private func pushToSignUpView() {
        coordinator?.pushToSignupView()
    }
    
    private func setupTextFieldDelegates() {
        emailTextFieldView.textField.delegate = self
        passwordTextFieldView.textField.delegate = self
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let active = activeTextField,
              (active == emailTextFieldView.textField ||
               active == passwordTextFieldView.textField),
              let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        UIView.animate(withDuration: 0.5) {
            self.view.transform = CGAffineTransform(
                translationX: 0,
                y: -keyboardHeight * 0.6
            )
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
}

extension LoginViewController: View {
    func bind(reactor: LoginReactor) {
        bindInput(to: reactor)
        bindOutput(to: reactor)
    }
    
    func bindInput(to reactor: LoginReactor) {

        emailTextFieldView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.emailTextChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailTextFieldView.textField.rx.controlEvent(.editingDidBegin)
            .map { EveryTipTextFieldStatus.editing }
            .bind(to: emailTextFieldView.status)
            .disposed(by: disposeBag)
        
        emailTextFieldView.textField.rx.controlEvent(.editingDidEnd)
            .map {  EveryTipTextFieldStatus.normal }
            .bind(to: emailTextFieldView.status)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.passwordTextChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.textField.rx.controlEvent(.editingDidBegin)
            .map { EveryTipTextFieldStatus.editing }
            .bind(to: passwordTextFieldView.status)
            .disposed(by: disposeBag)
        
        passwordTextFieldView.textField.rx.controlEvent(.editingDidEnd)
            .map {  EveryTipTextFieldStatus.normal }
            .bind(to: passwordTextFieldView.status)
            .disposed(by: disposeBag)

        loginButton.rx.tap
            .map { Reactor.Action.loginButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        searchPasswordButton.rx.tap
            .map { Reactor.Action.searchPasswordButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(to reactor: LoginReactor) {
        reactor.pulse(\.$toastMessage)
            .subscribe(onNext: { [weak self] message in
                guard let message = message else { return }
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$navigationSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.popToRootView()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$forgotPasswordSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.pushToForgotPasswordView()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if activeTextField == textField {
            activeTextField = nil
        }
    }
}
