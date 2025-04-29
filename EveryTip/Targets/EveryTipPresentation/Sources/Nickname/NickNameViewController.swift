//
//  NickNameViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/16/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

import ReactorKit

final class NicknameViewController: BaseViewController {
    
    weak var coordinator: NicknameCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let titleView: TitleDescriptionView = {
        let view = TitleDescriptionView(
            title: "닉네임 설정",
            subTitle: "사용할 닉네임을 설정해주세요.\n고민되면 랜덤 생성하기를 이용하세요!"
        )
        return view
    }()
    
    private let nicknameGuideLineLabel: UILabel = {
        let label = UILabel()
        label.text = "*공백 및 특수문자 불가/한글 최대 8글자/영어 12글자"
        label.font = .et_pretendard(
            style: .regular,
            size: 14
        )
        label.textColor = .et_textColorBlack30
        
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .et_pretendard(
            style: .medium,
            size: 16
        )
        label.textColor = .et_textColorBlack70
        
        return label
    }()
    
    private let nickNameTextField: EveryTipTextFieldView = {
        let textFieldView = EveryTipTextFieldView(
            hasClearButton: false,
            hasSecureTextButton: false,
            textFieldRightInset: 40
        )
        textFieldView.textField.placeholder = "닉네임을 설정해주세요"
        
        return textFieldView
    }()
    
    private let checkDuplicationButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .et_pretendard(
            style: .bold,
            size: 14
        )
        button.tintColor = .et_brandColor2
        button.backgroundColor = .et_brandColor2.withAlphaComponent(0.15)
        button.layer.cornerRadius = 6
        button.setTitle("중복확인", for: .normal)
        
        return button
    }()
    
    private let setRandomNicknameButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 6
        configuration.image = UIImage.et_getImage(for: .refresh)
        let attributedTitle = AttributedString(
            "랜덤 설정하기",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .bold, size: 14),
                .foregroundColor: UIColor.et_textColorBlack30
            ])
        )
        configuration.attributedTitle = attributedTitle
        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 6
        button.backgroundColor = .et_lineGray20
        
        return button
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
    
    init(reactor: NicknameReactor) {
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addDashedBorder(to: setRandomNicknameButton)
    }
    
    private func setupLayout() {
        view.addSubViews(
            titleView,
            nicknameGuideLineLabel,
            nicknameLabel,
            nickNameTextField,
            checkDuplicationButton,
            setRandomNicknameButton,
            confirmButton
        )
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        nicknameGuideLineLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameGuideLineLabel.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.greaterThanOrEqualTo(52)
        }
        checkDuplicationButton.snp.makeConstraints {
            $0.trailing.equalTo(nickNameTextField.snp.trailing).offset(-8)
            $0.width.equalTo(74)
            $0.height.equalTo(36)
            $0.centerY.equalTo(nickNameTextField.textField.snp.centerY)
        }
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.equalTo(56)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        setRandomNicknameButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.bottom.equalTo(confirmButton.snp.top).offset(-20)
            $0.width.equalTo(208)
            $0.height.equalTo(43)
        }
    }
    
    private func addDashedBorder(to button: UIButton) {
        let dashedBorder = CAShapeLayer()
        dashedBorder.strokeColor = UIColor.et_lineGray40.cgColor
        dashedBorder.fillColor = nil
        dashedBorder.lineDashPattern = [4, 2]
        dashedBorder.lineWidth = 1
        dashedBorder.frame = button.bounds
        dashedBorder.path = UIBezierPath(
            roundedRect: button.bounds,
            cornerRadius: button.layer.cornerRadius
        ).cgPath
        button.layer.addSublayer(dashedBorder)
    }
}

extension NicknameViewController: View {
    func bind(reactor: NicknameReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: NicknameReactor) {
        nickNameTextField.textField.rx.controlEvent(.editingChanged)
            .map {
                EveryTipTextFieldStatus.editing
            }
            .bind(to: nickNameTextField.status)
            .disposed(by: disposeBag)
        
        // 텍스트 변경 → Reactor
        
        nickNameTextField.action
            .compactMap { action -> String? in
                if case let .textChanged(text) = action { return text }
                return nil
            }
            .map { NicknameReactor.Action.textChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
        checkDuplicationButton.rx.tap
            .map { NicknameReactor.Action.checkDuplication }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        setRandomNicknameButton.rx.tap
            .map { NicknameReactor.Action.randomButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { NicknameReactor.Action.confirmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: NicknameReactor) {
        reactor.state
            .map { $0.nicknameText }
            .distinctUntilChanged()
            .bind(to: nickNameTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.validationResult.message }
            .bind(to: nickNameTextField.guideMessageLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.validationResult }
            .distinctUntilChanged()
            .map { $0 == .valid ? UIColor.et_brandColor2 : UIColor.et_textColor5 }
            .bind(to: confirmButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.validationResult }
            .distinctUntilChanged()
            .map { validation -> EveryTipTextFieldStatus in
                switch validation {
                case .none:
                    return .normal
                case .valid:
                    return .success
                case .empty, .invalidFormat, .duplicated:
                    return .error
                }
            }
            .bind(to: nickNameTextField.status)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
    }
}
