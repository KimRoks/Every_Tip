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
        label.font = .et_pretendard(style: .regular, size: 14)
        label.textColor = .et_textColorBlack30
        
        return label
    }()
    
    private let nicknameLable: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .et_pretendard(style: .medium, size: 16)
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
                .font: UIFont.et_pretendard(
                    style: .bold,
                    size: 14
                ),
                .foregroundColor: UIColor.et_textColorBlack30,
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
        button.setTitle("다음", for: .normal)
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
            nicknameLable,
            nickNameTextField,
            checkDuplicationButton,
            setRandomNicknameButton,
            confirmButton
        )
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints { $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        nicknameGuideLineLabel.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nicknameLable.snp.makeConstraints {
            $0.top.equalTo(nicknameGuideLineLabel.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameLable.snp.bottom).offset(12)
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
        dashedBorder.lineDashPattern = [4, 2] // 점선 (4pt 그려지고 2pt 비워짐)
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
    
    func bindInput(reactor: NicknameReactor) {
        setRandomNicknameButton.rx.tap
            .map { Reactor.Action.randomButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        checkDuplicationButton.rx.tap
            .withLatestFrom(nickNameTextField.textField.rx.text.orEmpty)
            .map { Reactor.Action.checkDuplication(nickName: $0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nickNameTextField.action
            .map { action in
                switch action {
                case .editingDidBegin:
                    return Reactor.Action.textEditingDidBegin
                case .editingDidEnd:
                    return Reactor.Action.textEditingDidEnd
                case .editingDidEndOnExit:
                    return Reactor.Action.textDidEndOnExit
                case .textChanged(text: let text):
                    return Reactor.Action.textChanged(text)
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map {
                Reactor.Action.confirmButtonTapped
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: NicknameReactor) {
        reactor.state
            .map { $0.nicknameText }
            .distinctUntilChanged()
            .bind(to: nickNameTextField.textField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isCheckedDuplication }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isChecked in
                self?.confirmButton.backgroundColor = isChecked ? .et_brandColor2 : .et_textColor5
            })
        
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.nicknameInputState }
            .bind(with: self) { owner, state in
                switch state {
                case .normal:
                    owner.nickNameTextField.guideMessageLabel.text = nil
                    owner.nickNameTextField.status.onNext(.normal)
                case .editing:
                    owner.nickNameTextField.guideMessageLabel.text = nil
                    owner.nickNameTextField.status.onNext(.editing)
                    
                case .success(let reason):
                    owner.nickNameTextField.guideMessageLabel.text = reason.message
                    owner.nickNameTextField.status.onNext(.success)
                    
                case .error(let reason):
                    owner.nickNameTextField.guideMessageLabel.text = reason.message
                    owner.nickNameTextField.status.onNext(.error)
                    
                case .notEnabled:
                    owner.nickNameTextField.guideMessageLabel.text = nil
                    owner.nickNameTextField.status.onNext(.notEnabled)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .subscribe { [weak self] message in
                self?.showToast(message: message)
            }
            .disposed(by: disposeBag)
    }
}
