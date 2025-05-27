//
//  CommentTableViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 5/22/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import Kingfisher

final class CommentTableViewCell: UITableViewCell, Reusable {
    private let commenterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .et_getImage(for: .blankImage)
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let commenterNameLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .bold, size: 10)
        
        return label
    }()
    
    private let commenttedTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(style: .medium, size: 10)
        
        return label
    }()
    
    private let writerBadgeLabel: InsetLabel = {
        let label = InsetLabel(
            top: 2,
            left: 4,
            bottom: 2,
            right: 4
        )
        label.text = "작성자"
        label.textColor = UIColor(hex: "#5ACC90")
        label.backgroundColor = UIColor(hex: "#5ACC90", alpha: 0.1)
        label.font = .et_pretendard(
            style: .medium,
            size: 8
        )
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.isHidden = true
        
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.font = .et_pretendard(
            style: .medium,
            size: 12
        )
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    private let addReplyButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .reply)
        configuration.imagePadding = 2
        var attributedTitle = AttributedString("답글 쓰기")
        attributedTitle.font = UIFont.et_pretendard(style: .bold, size: 10)
        configuration.attributedTitle = attributedTitle
        
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .et_textColorBlack30
        return button
    }()
    
    private let commentsLikebutton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = .et_getImage(for: .likeImage_empty)
        configuration.imagePadding = 2
        
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        var attributedTitle = AttributedString("좋아요")
        attributedTitle.font = UIFont.et_pretendard(style: .bold, size: 10)
        configuration.attributedTitle = attributedTitle
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .et_textColorBlack30
        
        return button
    }()
    
    private let separator: StraightLineView = {
        let line = StraightLineView(color: UIColor(hex: "#F6F6F6"))
        
        return line
    }()
    
    // MARK: Life Cycles
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = self.bounds.inset(
            by: UIEdgeInsets(
                top: 0,
                left: CGFloat(indentationLevel * Int(indentationWidth)),
                bottom: 0,
                right: 0
            )
        )
    }
    
    // MARK: Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.indentationLevel = 1
        self.indentationWidth = 50
        setupLayout()
        setupConstraints()
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Method
    
    private func setupLayout() {
        contentView.addSubViews(
            commenterImageView,
            commenterNameLabel,
            commenttedTimeLabel,
            writerBadgeLabel,
            commentLabel,
            addReplyButton,
            commentsLikebutton,
            separator
        )
    }
    
    private func setupConstraints() {
        commenterImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(14)
            $0.leading.equalTo(contentView.snp.leading).offset(26)
            $0.height.width.equalTo(32)
        }
        
        commenterNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(14)
            $0.leading.equalTo(commenterImageView.snp.trailing).offset(6)
        }
        
        commenttedTimeLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(14)
            $0.leading.equalTo(commenterNameLabel.snp.trailing).offset(4)
        }
        
        writerBadgeLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(14)
            $0.leading.equalTo(commenttedTimeLabel.snp.trailing).offset(4)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(30)
            $0.leading.equalTo(commenterImageView.snp.trailing).offset(6)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-40)
        }
        
        addReplyButton.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(64)
            $0.top.equalTo(commentLabel.snp.bottom).offset(6)
        }
        
        commentsLikebutton.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(6)
            $0.leading.equalTo(addReplyButton.snp.trailing).offset(6)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(addReplyButton.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.bottom.equalTo(contentView.snp.bottom).priority(.required)
        }
    }
    
    // MARK: Internal Method
    
    func configureCell(with data: Comment) {
        if let profileImageUrl = data.writer.profileImage {
            commenterImageView.kf.setImage(
                with: URL(string: profileImageUrl),
                placeholder: UIImage.et_getImage(for: .blankImage)
            )
        }
        
        commenterNameLabel.text = data.writer.name
        commenttedTimeLabel.text = data.createdAt.timeAgo()
        commentLabel.text = data.content
        
        commentsLikebutton.configuration?.attributedTitle = AttributedString(
            "좋아요 \(data.likes)",
            attributes: AttributeContainer(
                [.font: UIFont.et_pretendard(style: .bold, size: 10)]
            )
        )
        
        if data.isMine == true {
            writerBadgeLabel.isHidden = false
        }
        
        if data.isLiked == true {
            commentsLikebutton.configuration?.image = .et_getImage(for: .likeImage_fill)
        }
        
        self.indentationWidth = data.parentID != nil ? 38 : 0
    }
    
    func toggleLike() {
        let currentConfig = commentsLikebutton.configuration
        
        let emptyImage = UIImage.et_getImage(for: .likeImage_empty)
        let fillImage = UIImage.et_getImage(for: .likeImage_fill)
        
        let newImage = currentConfig?.image == fillImage ? emptyImage : fillImage
        commentsLikebutton.configuration?.image = newImage
    }
}
