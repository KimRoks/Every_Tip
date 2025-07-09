//
//  TipListCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/3/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

import EveryTipDesignSystem
import EveryTipDomain

final class TipListCell: UITableViewCell, Reusable {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.et_pretendard(style: .bold, size: 16)
        
        return label
    }()
    
    private let mainTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 14
        )
        label.numberOfLines = 2
        label.textColor = UIColor.et_textColorBlack50
        
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.image = .et_getImage(for: .blankImage)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.et_pretendard(
            style: .medium,
            size: 12
        )
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    private let viewsImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.et_getImage(for: .viewsImage)
        
        return imageview
    }()
    
    private let viewsCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    private let commentsImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.et_getImage(for: .commentImage)
        
        return imageview
    }()
    
    private let commentsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.text = "0"
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    private let likesImage: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage.et_getImage(for: .likeImage_empty)
        imageview.tintColor = UIColor(hex: "#777777")
        
        return imageview
    }()
    
    private let likesCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.et_pretendard(style: .medium, size: 12)
        label.textColor = UIColor(hex: "#777777")
        
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "#F1F1F1")
        
        return view
    }()
    
    // MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = UIImage.et_getImage(for: .blankImage)
    }

    
    // MARK: Private Methods

    private func configureTitleLabelText(_ text: String) {
        let categoryWidth = calculateLabelWidth(for: categoryLabel)
        let space = createDynamicSpace(forWidth: categoryWidth, withFont: titleLabel.font)
        let titleText = text
        titleLabel.text = space + titleText
    }
    
    private func configureCategoryLabel(id: Int) {
        categoryLabel.setCategory(with: id)
    }
    
    private func updateLikeImage(isLiked: Bool) {
        let image = isLiked
        ? UIImage.et_getImage(for: .likeImage_fill)
        : UIImage.et_getImage(for: .likeImage_empty)
        
        likesImage.image = image
    }
    
    private func updateThumbnailImage(with urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            thumbnailImageView.image = UIImage.et_getImage(for: .blankImage)
            return
        }

        thumbnailImageView.kf.setImage(
            with: url,
            placeholder: UIImage.et_getImage(for: .blankImage),
            options: [
                .transition(.fade(0.3)),
                .forceTransition,
                .cacheOriginalImage
              ]
        )
    }
        
    private func calculateLabelWidth(for label: UILabel) -> CGFloat {
        guard let text = label.text else { return 0 }
        let font = label.font ?? UIFont.et_pretendard(style: .bold, size: 12)
        let size = (text as NSString).size(withAttributes: [.font: font])
        return size.width + 5 // 텍스트 패딩 포함
    }
    
    private func createDynamicSpace(forWidth width: CGFloat, withFont font: UIFont) -> String {
        let spaceCharWidth = " ".size(withAttributes: [.font: font]).width // 공백 문자 하나의 넓이
        let spaceCount = Int(ceil(width / spaceCharWidth)) // 필요한 공백 문자 수 계산
        return String(repeating: " ", count: spaceCount)
    }
    
    // MARK: Layout Methods
    
    private func setupLayout() {
        contentView.addSubViews(
            categoryLabel,
            titleLabel,
            mainTextLabel,
            viewsImage,
            viewsCountLabel,
            commentsImage,
            commentsCountLabel,
            likesImage,
            likesCountLabel,
            thumbnailImageView,
            userNameLabel,
            separatorView
        )
    }
    
    private func setupConstraints() {
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.height.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-20)
        }
        
        mainTextLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.trailing.equalTo(thumbnailImageView.snp.leading).offset(-10)
            $0.height.equalTo(40)
        }
        
        viewsImage.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
            $0.height.equalTo(viewsCountLabel)
        }
        
        viewsCountLabel.snp.makeConstraints {
            $0.leading.equalTo(viewsImage.snp.trailing).offset(4)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
        
        commentsImage.snp.makeConstraints {
            $0.leading.equalTo(viewsCountLabel.snp.trailing).offset(8)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
            $0.height.equalTo(commentsCountLabel)
        }
        
        commentsCountLabel.snp.makeConstraints {
            $0.leading.equalTo(commentsImage.snp.trailing).offset(4)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
        
        likesImage.snp.makeConstraints {
            $0.leading.equalTo(commentsCountLabel.snp.trailing).offset(8)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
            $0.height.equalTo(likesCountLabel)
        }
        
        likesCountLabel.snp.makeConstraints {
            $0.leading.equalTo(likesImage.snp.trailing).offset(4)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    
        thumbnailImageView.snp.makeConstraints{
            $0.top.equalTo(contentView.snp.top).offset(20)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.height.equalTo(90)
            $0.width.equalTo(90)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(thumbnailImageView.snp.bottom).offset(10)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-20)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
        
        separatorView.snp.makeConstraints {
            $0.bottom.equalTo(contentView.snp.bottom)
            $0.leading.trailing.equalTo(contentView).inset(20)
            $0.height.equalTo(1)
        }
    }
    
    // MARK: internal methods
    
    func configureTipListCell(with item: Tip) {
        thumbnailImageView.image = UIImage.et_getImage(for: .blankImage)
        
        let thumbnailURL = item.images.first(where: { $0.isThumbnail == 1 })?.url
        self.updateThumbnailImage(with: thumbnailURL)
        self.updateLikeImage(isLiked: item.isLiked)
        self.configureCategoryLabel(id: item.categoryId)
        self.configureTitleLabelText(item.title)
        
        self.mainTextLabel.text = item.content
        self.userNameLabel.text = "by \(item.writer.name)"
        self.commentsCountLabel.text = "\(item.commentsCount)"
        self.viewsCountLabel.text = "\(item.views)"
        self.likesCountLabel.text = "\(item.likes)"
    }
}
