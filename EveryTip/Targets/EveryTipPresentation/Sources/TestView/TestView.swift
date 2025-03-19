//
//  TestView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import SnapKit

final class TestView: UIViewController {
    weak var coordinator: TestViewCoordinator?
    
    var tip: Tip?
    
    private let titleLabel: TitleDescriptionView = {
        let view = TitleDescriptionView(
            title: "닉네임 설정",
            subTitle: "사용할 닉네임을 설정해주세요\n고민되면 랜덤 생성하기를 이용하세요!"
     )
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "*공백 및 특수문자 불가/한글최대 8글자/영어 12글자"
        label.font = .et_pretendard(style: .regular, size: 14)
        label.textColor = .et_textColorBlack30
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .et_pretendard(style: .medium, size: 16)
        
        return label
    }()
    
    private let nickNameTextFieldView: EveryTipTextFieldView = {
        let textfieldView = EveryTipTextFieldView(hasClearButton: false)
        textfieldView.textField.placeholder = "닉네임을 설정해주세요"
        
        return textfieldView
    }()
    
    private let checkNickNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("중복확인", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .bold, size: 14)
        button.backgroundColor = .et_brandColor2.withAlphaComponent(0.15)
        button.setTitleColor(.et_brandColor2, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let randomButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        configuration.image = .et_getImage(for: .reload)
        configuration.imagePadding = 6
        configuration.background.backgroundColor = .et_lineGray20
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.et_pretendard(style: .bold, size: 16),
            .foregroundColor: UIColor.et_textColorBlack30
        ]
        let attributedTitle = NSAttributedString(string: "랜덤 설정하기", attributes: attributes)
        configuration.attributedTitle = AttributedString(attributedTitle)

        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.backgroundColor = .et_textColor5
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.tintColor = .white
        
        return button
    }()
    
    init(tip: Tip?) {
        super.init(nibName: nil, bundle: nil)
        self.tip = tip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print(tip)
        view.backgroundColor = .white
        setLayout()
        setConstraints()
    }
    
    private func setLayout() {
        view.addSubViews(
            titleLabel,
            nickNameLabel,
            descriptionLabel,
            nickNameTextFieldView,
            checkNickNameButton,
            randomButton,
            confirmButton
        )
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        nickNameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(12)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        checkNickNameButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalTo(nickNameTextFieldView).inset(8)
            $0.width.equalTo(nickNameTextFieldView.snp.width).multipliedBy(0.22)
        }
        
        randomButton.snp.makeConstraints {
            $0.bottom.equalTo(confirmButton.snp.top).offset(-20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(83)
            $0.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(view.snp.height).multipliedBy(0.07)
        }
    }
}
