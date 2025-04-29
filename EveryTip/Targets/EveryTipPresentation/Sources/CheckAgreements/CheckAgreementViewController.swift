//
//  CheckAgreementViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/21/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

import ReactorKit

final class CheckAgreementViewController: BottomSheetViewController, ToastDisplayable {
    
    var disposeBag: DisposeBag = DisposeBag()
    weak var coordinator: CheckAgreementCoordinator?
    
    private let checkMarkNormal: UIImage = {
        return .et_getImage(for: .checkMark_normal)
    }()
    
    private let checkMarkCircle: UIImage = {
        return .et_getImage(for: .checkMark_circle)
    }()
    
    private let checkedMarkCicle: UIImage = {
        return .et_getImage(for: .checkedMark_circle)
    }()
    
    private let checkedMarkNormal: UIImage = {
        return .et_getImage(for: .checkedMark_normal)
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "에브리팁 이용을 위한\n약관 동의가 필요해요."
        label.numberOfLines = 2
        label.font = .et_pretendard(style: .bold, size: 20)
        label.textColor = .black
        
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.et_lineGray40.cgColor
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    private let agreeAllButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .checkMark_circle)
        
        let attributedTitle = AttributedString(
            "전체 약관 동의",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(style: .medium, size: 16)
            ])
        )
        configuration.attributedTitle = attributedTitle
        configuration.imagePadding = 10
        configuration.baseForegroundColor = UIColor.black
        
        let button = UIButton(type: .system)
        button.configuration = configuration
        
    
        return button
    }()
    
    private let requiredTermsAgreementButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .checkMark_normal)
        
        configuration.attributedTitle = AttributedString(
            "(필수) 이용 약관 동의",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(
                    style: .regular,
                    size: 14
                )
            ])
        )
        configuration.baseForegroundColor = UIColor.et_textColorBlack10
        configuration.imagePadding = 10
        
        let button = UIButton(type: .system)
        button.configuration = configuration
        
        return button
    }()
    
    private let requiredMoreButton: UIButton = {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.et_pretendard(style: .regular, size: 14),
            .foregroundColor: UIColor.et_textColorBlack10,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.et_textColorBlack10
        ]
        
        let attributedTitle = NSAttributedString(
            string: "자세히 보기",
            attributes: attributes
        )
        
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    private let requiredStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let optionalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let optionalTermsAgreementButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .checkMark_normal)
        
        let attributedTitle = AttributedString(
            "이용 약관 및 개인정보취급방침",
            attributes: AttributeContainer([
                .font: UIFont.et_pretendard(
                    style: .regular,
                    size: 14
                )
            ])
        )
        
        configuration.attributedTitle = attributedTitle
        configuration.imagePadding = 10
        configuration.baseForegroundColor = UIColor.et_textColorBlack10

        let button = UIButton(configuration: configuration)
        
        return button
        
    }()
    
    private let optionalMoreButton: UIButton = {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.et_pretendard(style: .regular, size: 14),
            .foregroundColor: UIColor.et_textColorBlack10,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.et_textColorBlack10
        ]
        
        let attributedTitle = NSAttributedString(
            string: "자세히 보기",
            attributes: attributes
        )
        
        let button = UIButton(type: .system)
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .et_textColor5
        
        button.layer.cornerRadius = 10
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .bold,
            size: 18
        )
        button.tintColor = .white
        
        return button
    }()
    
    init(reactor: CheckAgreementsReactor) {
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

    
    private func setupLayout() {
        contentView.addSubViews(
            titleLabel,
            containerView,
            requiredStackView,
            optionalStackView,
            confirmButton
        )
        
        containerView.addSubview(agreeAllButton)
        
        requiredStackView.addArrangedSubViews(
            requiredTermsAgreementButton,
            requiredMoreButton
        )
        
        optionalStackView.addArrangedSubViews(
            optionalTermsAgreementButton,
            optionalMoreButton
        )
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(32)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(52)
        }
        
        agreeAllButton.snp.makeConstraints {
            $0.centerY.equalTo(containerView.snp.centerY)
            $0.leading.equalTo(containerView.snp.leading).offset(20)
        }
        
        requiredStackView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(contentView).inset(40)
        }
      
        optionalStackView.snp.makeConstraints {
            $0.top.equalTo(requiredStackView.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(contentView).inset(40)
        }
    
        confirmButton.snp.makeConstraints {
            $0.height.equalTo(contentView.snp.height).multipliedBy(0.16)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-20)
        }
    }
}

extension CheckAgreementViewController: View {
    func bind(reactor: CheckAgreementsReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: CheckAgreementsReactor) {
        agreeAllButton.rx.tap
            .map { Reactor.Action.agreeAllButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        requiredTermsAgreementButton.rx.tap
            .map { Reactor.Action.requiredButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        optionalTermsAgreementButton.rx.tap
            .map { Reactor.Action.optionalButtonTapped }
            .bind(to: reactor.action)
             .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonTapped}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    func bindOutput(reactor: CheckAgreementsReactor) {
        reactor.state.map { $0.isRequiredChecked }
            .subscribe { [weak self] isChecked in
                guard let button = self?.requiredTermsAgreementButton else { return }
                // UIButton.Configuration은 값 타입이므로, 새로 복사해서 수정 후 재할당해야 함
                var config = button.configuration ?? UIButton.Configuration.plain()
                config.image = isChecked ? self?.checkedMarkNormal : self?.checkMarkNormal
                button.configuration = config
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isOptionalChecked }
            .subscribe { [weak self] isChecked in
                guard let button = self?.optionalTermsAgreementButton else { return }
                var config = button.configuration ?? UIButton.Configuration.plain()
                config.image = isChecked ? self?.checkedMarkNormal : self?.checkMarkNormal
                button.configuration = config
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isAllChecked  }
            .subscribe(onNext: { [weak self] isChecked in
                if isChecked {
                    self?.containerView.layer.borderColor = UIColor.et_brandColor2.cgColor
                    
                    var config = self?.agreeAllButton.configuration ?? UIButton.Configuration.plain()
                    config.image = self?.checkedMarkCicle
                    self?.agreeAllButton.configuration = config
                    
                } else {
                    self?.containerView.layer.borderColor = UIColor.et_lineGray40.cgColor
                    var config = self?.agreeAllButton.configuration ?? UIButton.Configuration.plain()
                    config.image = self?.checkMarkCircle
                    self?.agreeAllButton.configuration = config
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isConfirmable }
            .subscribe(onNext: { [weak self] isConfirmable in
                guard let self = self else { return }
                self.confirmButton.backgroundColor =
                isConfirmable ? .et_brandColor2
                : .et_textColor5
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .subscribe(onNext: { [weak self] message in
                guard let message = message else { return }
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$navigationSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                
                self?.coordinator?.pushToSignupSuccessView()
            })
            .disposed(by: disposeBag)
    }
}
