//
//  PostView.swift
//  EveryTip
//
//  Created by 김경록 on 2/22/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

protocol PostViewDelegate: AnyObject {
    func didRequestDismiss(_ Sender: PostView)
}

final class PostView: UIView {
    
    //MARK: Property
    
    weak var delegate: PostViewDelegate?
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "x.square"), for: .normal)
        button.tintColor = .black
        button.addTarget(nil, action: #selector(didRequestDismiss), for: .touchUpInside)
        
        return button
    }()
    
    private let topTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "팁 추가"
        
        return label
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("등록", for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [closeButton,
                                                   topTitleLabel,
                                                   registerButton])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        
        closeButton.snp.makeConstraints { make in
            make.width.equalTo(registerButton.snp.width)
        }
        topTitleLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(closeButton.snp.width)
        }
        
        return stack
    }()
    
    private lazy var categoryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryLabel,
                                                   categorydetailButton])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally

        categorydetailButton.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
    
        return stack
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리 선택"
        
        return label
    }()
    
    private let categorydetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.tintColor = UIColor.EveryTip.textColor5
        button.contentMode = .center

        return button
    }()
    
    private lazy var categoryUnderLine: UIView = {
        return createLine()
    }()
    
    private lazy var hashTagStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hashTagLabel,
                                                   hashTagDetailButton])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally

        hashTagDetailButton.snp.makeConstraints { make in
            make.width.equalTo(15)
        }
        
        return stack
    }()
    
    private let hashTagLabel: UILabel = {
        let label = UILabel()
        label.text = "#태그 입력(최대 00개)"
        
        return label
    }()
    
    private let hashTagDetailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.tintColor = UIColor.EveryTip.textColor5
        
        return button
    }()
    
    private lazy var hashTagUnderLine: UIView = {
        return createLine()
    }()
    
    private let titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "제목을 입력하세요"
        field.font = .systemFont(ofSize: 20, weight: UIFont.Weight(rawValue: 700))
        
        return field
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용 입력"
        textView.textColor = UIColor.placeholderText
        textView.font = .systemFont(ofSize: 16, weight: UIFont.Weight(rawValue: 500))
        
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        return textView
    }()
    
    private let addedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.backgroundColor = .black
        
        return imageView
    }()
    
    private lazy var bodyUnderLine: UIView = {
        return createLine()
    }()
    
    private let addImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.square"), for: .normal)
        button.setTitle("이미지", for: .normal)
        button.tintColor = UIColor.EveryTip.textColor5
        
        return button
    }()
    
    private let addLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "link.circle"), for: .normal)
        button.setTitle("링크", for: .normal)
        button.tintColor = UIColor.EveryTip.textColor5
        
        return button
    }()
    
    private lazy var attachmentStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addImageButton,
                                                   addLinkButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        return stack
    }()
    
    // TODO: 저장 숫자 카운팅 설정
    private let temporaryStorageButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("임시 저장 0", for: .normal)
        button.tintColor = UIColor.EveryTip.textColor5
        
        return button
    }()
    
    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Private Methods
    
    private func configureLayout() {
        self.backgroundColor = .white
        
        addSubview(topStackView)
        addSubview(categoryStackView)
        addSubview(categoryUnderLine)
        addSubview(hashTagStackView)
        addSubview(hashTagUnderLine)
        addSubview(titleTextField)
        addSubview(bodyTextView)
        addSubview(addedImageView)
        addSubview(bodyUnderLine)
        addSubview(attachmentStackView)
        addSubview(temporaryStorageButton)
        
        topStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(30)
        }
        
        categoryStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(30)
        }
        
        categoryUnderLine.snp.makeConstraints { make in
            make.top.equalTo(categoryStackView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
        hashTagStackView.snp.makeConstraints { make in
            make.top.equalTo(categoryUnderLine.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(30)
        }
        
        hashTagUnderLine.snp.makeConstraints { make in
            make.top.equalTo(hashTagStackView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(hashTagUnderLine.snp.bottom).offset(20)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(24)
        }
        
        bodyTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
        }
        
        addedImageView.snp.makeConstraints { make in
            make.top.equalTo(bodyTextView.snp.bottom).offset(30)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            
            make.height.equalTo(70)
            make.width.equalTo(70)
            make.bottom.equalTo(bodyUnderLine.snp.top).offset(-30)
        }
        
        bodyUnderLine.snp.makeConstraints { make in
            make.bottom.equalTo(attachmentStackView.snp.top).offset(-10)
            make.leading.equalTo(safeAreaLayoutGuide)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        attachmentStackView.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(34)
        }
        
        temporaryStorageButton.snp.makeConstraints { make in
            make.trailing.equalTo(safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
    }
    
    @objc
    private func didRequestDismiss() {
        delegate?.didRequestDismiss(self)
    }
    
    private func createLine() -> UIView {
        let line = UIView()
        line.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
        line.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        return line
    }
}
