//
//  ForgotPasswordViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/21/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit
import ReactorKit
import RxSwift

final class ForgotPasswordViewController: BaseViewController {
    
    var disposeBag: DisposeBag = DisposeBag()
    
    weak var coordinator: ForgotPasswordCoordinator?
    
    private let titleView: TitleDescriptionView = {
        let view = TitleDescriptionView(
            title: "비밀번호 재설정",
            subTitle: "이메일로 새로운 비밀번호를 전송해드려요."
        )
        
        return view
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.font = .et_pretendard(
            style: .medium,
            size: 16
        )
        label.textColor = .et_textColorBlack70
        
        return label
    }()
    
    private let emailTextFieldView: EveryTipTextFieldView = {
        let view = EveryTipTextFieldView(hasClearButton: true)
        view.textField.placeholder = "이메일 입력"
        
        return view
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "다음",
            for: .normal
        )
        button.tintColor = .white
        button.titleLabel?.font = .et_pretendard(
            style: .regular,
            size: 18
        )
        button.backgroundColor = .et_textColor5
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init(reactor: ForgotPasswordReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    @MainActor
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
    }
    
    private func setupLayout() {
        view.addSubViews(
            titleView,
            emailLabel,
            emailTextFieldView,
            confirmButton
        )
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(32)
            $0.leading.equalTo(view.snp.leading).offset(20)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.leading.equalTo(view.snp.leading).offset(20)
        }
        
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view).inset(20)
        }
        
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(view).inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(56)
        }
    }
}

extension ForgotPasswordViewController: View {
    func bind(reactor: ForgotPasswordReactor) {
        bindInput(reactor: reactor)
        bindOutut(reactor: reactor)
    }
    
    func bindInput(reactor: ForgotPasswordReactor) {
        emailTextFieldView.textField.rx.controlEvent(.editingDidBegin)
            .map { EveryTipTextFieldStatus.editing }
            .bind(to: emailTextFieldView.status)
            .disposed(by: disposeBag)
        
        emailTextFieldView.textField.rx.controlEvent(.editingDidEnd)
            .map {  EveryTipTextFieldStatus.normal }
            .bind(to: emailTextFieldView.status)
            .disposed(by: disposeBag)
        
        emailTextFieldView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .map { Reactor.Action.textChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutut(reactor: ForgotPasswordReactor) {
        reactor.state
            .map { !$0.emailText.isEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isValid in
                self?.confirmButton.isEnabled = isValid
                self?.confirmButton.backgroundColor = isValid ? .et_brandColor2 : .et_textColor5
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$completedSignal)
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.popToRootView()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap{ $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
    }
}
