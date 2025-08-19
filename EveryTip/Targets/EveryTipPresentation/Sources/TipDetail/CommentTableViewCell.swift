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

import RxSwift

final class CommentTableViewCell: UITableViewCell, Reusable {
    
    let profileImageTapped = PublishSubject<Void>()
    let ellipsisTapped = PublishSubject<Void>()
    let likeButtonTapped = PublishSubject<Void>()
    
    var disposeBag = DisposeBag()
    private let userProfileTapGesture = UITapGestureRecognizer()
    
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
    
    private let ellipsisButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            .et_getImage(for: .ellipsis)
            , for: .normal)
        button.tintColor = .et_textColorBlack30
        
        return button
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
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: Private Method
    private func setupLayout() {
        contentView.addSubViews(
            commenterImageView,
            commenterNameLabel,
            commenttedTimeLabel,
            writerBadgeLabel,
            commentLabel,
            commentsLikebutton,
            ellipsisButton,
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
        
        commentsLikebutton.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(6)
            $0.leading.equalTo(contentView.snp.leading).offset(64)
        }
        
        separator.snp.makeConstraints {
            $0.top.equalTo(commentsLikebutton.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.bottom.equalTo(contentView.snp.bottom).priority(.required)
        }
        
        ellipsisButton.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(37)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.width.equalTo(12)
        }
    }
    
    private func setupGesture() {
        commenterImageView.addGestureRecognizer(userProfileTapGesture)
        commenterImageView.isUserInteractionEnabled = true
    }
    
    // MARK: Internal Method
    
    func setupAction() {
        ellipsisButton.rx.tap
            .bind(to: ellipsisTapped)
            .disposed(by: disposeBag)
        
        commentsLikebutton.rx.tap
            .bind(to: likeButtonTapped)
            .disposed(by: disposeBag)
        
        userProfileTapGesture.rx.event
            .map { _ in }
            .bind(to: profileImageTapped)
            .disposed(by: disposeBag)
    }
    
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
        
        let likeImage: UIImage = data.isLiked ?
            .et_getImage(for: .likeImage_fill) :
            .et_getImage(for: .likeImage_empty)
        
        commentsLikebutton.configuration?.image = likeImage
        
        self.indentationWidth = data.parentID != nil ? 38 : 0
    }
}
