//
//  PhotoDetailCollcetionViewCell.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/14/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

final class PhotoDetailCollectionViewCell: UICollectionViewCell, Reusable {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with urlString: String) {
        if let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }
    }
}
