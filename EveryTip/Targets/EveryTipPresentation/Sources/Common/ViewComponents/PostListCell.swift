//
//  PostListCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

final class PostListCell: UITableViewCell {
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        return stackView
    }()
    
    let mainTextView: UILabel = {
        let textView = UILabel()
        textView.font = UIFont(name: "Pretendard", size: 14)
        textView.numberOfLines = 2
        return textView
    }()
    
    let userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard", size: 12)
        
        return label
    }()
    
    private lazy var userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        return stackView
    }()
    
    private let viewCountImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "eye")
        
        return imageView
    }()
    
    let viewCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard", size: 12)
        
        return label
    }()
    
    private lazy var viewCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        return stackView
    }()
    
    let likeCountImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart")
        
        return imageView
    }()
    
    let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard", size: 12)
        
        return label
    }()
    
    private lazy var likeCountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 3
        
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fill
        
        return stackView
    }()
    
    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "postPreViewCell")
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        titleStackView.addArrangedSubview(categoryLabel)
        titleStackView.addArrangedSubview(titleLabel)
        
        userStackView.addArrangedSubview(userImage)
        userStackView.addArrangedSubview(userNameLabel)
        
        likeCountStackView.addArrangedSubview(likeCountImage)
        likeCountStackView.addArrangedSubview(likeCountLabel)
        
        viewCountStackView.addArrangedSubview(viewCountImage)
        viewCountStackView.addArrangedSubview(viewCountLabel)
        
        bottomStackView.addArrangedSubview(userStackView)
        bottomStackView.addArrangedSubview(likeCountStackView)
        bottomStackView.addArrangedSubview(viewCountStackView)
        
        self.addSubview(titleStackView)
        self.addSubview(mainTextView)
        self.addSubview(bottomStackView)
        self.addSubview(thumbnailImageView)
    }
    
    private func setupConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.width.equalTo(50)
            $0.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(3)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-5)
        }
        
        mainTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-5)
            $0.bottom.equalTo(self.snp.bottom).offset(-30)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.bottom.equalTo(self.snp.bottom).offset(-5)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.bottom.equalTo(self.snp.bottom).offset(-20)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
            $0.width.equalTo(thumbnailImageView.snp.height)
        }
    }
}
