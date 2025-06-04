//
//  PostTipViewController.swift
//  EveryTip
//
//  Created by 김경록 on 2/22/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit

final class PostTipViewController: BaseViewController {
    
    //MARK: Properties
    
    weak var coordinator: PostTipViewCoordinator?
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "x.square"),
            for: .normal
        )
        button.tintColor = .black
        
        return button
    }()
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팁 추가"
        label.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 18
        )
        
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "등록",
            for: .normal
        )
        button.titleLabel?.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        
        return stack
    }()
    
    private let choiceCategoryView: DetailDisclosureView = {
        return DetailDisclosureView(title: "카테고리 선택")
    }()
    
    private let categoryUnderLine: StraightLineView = StraightLineView(color: .et_brandColor4)
    
    private let hashtagView: DetailDisclosureView = {
        return DetailDisclosureView(title: "#태그 입력(최대 00개)")
    }()
    
    private let hashTagUnderLine: StraightLineView = StraightLineView(color: .et_brandColor4)
    
    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "제목을 입력하세요"
        field.font = UIFont.et_pretendard(
            style: .semiBold,
            size: 20
        )
        
        return field
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용 입력"
        textView.textColor = UIColor.placeholderText
        textView.font = UIFont.et_pretendard(
            style: .medium,
            size: 16
        )
        
        textView.isScrollEnabled = true
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        
        return textView
    }()
    
    private let addedImageView: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
    
        return button
    }()
    
    private let bodyUnderLine: StraightLineView = StraightLineView(color: .et_brandColor4)
   
    private let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "plus.square"),
            for: .normal
        )
        button.setTitle(
            "이미지",
            for: .normal
        )
        button.tintColor = .et_textColor5
        
        return button
    }()
    
    private let addLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "link.circle"),
            for: .normal
        )
        button.setTitle(
            "링크",
            for: .normal
        )
        button.tintColor = .et_textColor5
        
        return button
    }()
    
    private lazy var attachmentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        return stack
    }()
    
    // TODO: 저장 숫자 카운팅 설정
    private let temporaryStorageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(
            "임시 저장 0",
            for: .normal
        )
        button.tintColor = .et_textColor5
        
        return button
    }()
    
    //MARK: View Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        closeButton.addTarget(
            nil,
            action: #selector(dismissView),
            for: .touchUpInside
        )
        
        addImageButton.addTarget(
            self,
            action: #selector(presentPhotoPicker),
            for: .touchUpInside
        )
    }
    
    //MARK: Private Methods
    
    private func setupLayout() {
        view.addSubview(topStackView)
        topStackView.addArrangedSubview(closeButton)
        topStackView.addArrangedSubview(topTitleLabel)
        topStackView.addArrangedSubview(registerButton)
        
        view.addSubview(choiceCategoryView)
        view.addSubview(categoryUnderLine)
        view.addSubview(hashtagView)
        view.addSubview(hashTagUnderLine)
        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)
        view.addSubview(addedImageView)
        view.addSubview(bodyUnderLine)
        
        view.addSubview(attachmentStackView)
        attachmentStackView.addArrangedSubview(addImageButton)
        attachmentStackView.addArrangedSubview(addLinkButton)
        
        view.addSubview(temporaryStorageButton)
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints {
            $0.width.equalTo(registerButton.snp.width)
        }
        
        topTitleLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(closeButton.snp.width)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
        
        choiceCategoryView.snp.makeConstraints {
            $0.top.equalTo(topStackView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
        
        categoryUnderLine.snp.makeConstraints {
            $0.top.equalTo(choiceCategoryView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        hashtagView.snp.makeConstraints {
            $0.top.equalTo(categoryUnderLine.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(30)
        }
        
        hashTagUnderLine.snp.makeConstraints {
            $0.top.equalTo(hashtagView.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(hashTagUnderLine.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(24)
        }
        
        bodyTextView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        addedImageView.snp.makeConstraints {
            $0.top.equalTo(bodyTextView.snp.bottom).offset(30)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            
            $0.height.equalTo(70)
            $0.width.equalTo(70)
            $0.bottom.equalTo(bodyUnderLine.snp.top).offset(-30)
        }
        
        bodyUnderLine.snp.makeConstraints {
            $0.bottom.equalTo(attachmentStackView.snp.top).offset(-10)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        attachmentStackView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(34)
        }
        
        temporaryStorageButton.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(30)
        }
    }
    
    @objc
    private func dismissView() {
        coordinator?.didFinish()
    }
    
    @objc
    private func presentPhotoPicker() {
        coordinator?.presentPhotoPicker()
    }
}
