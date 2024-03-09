//
//  ViewComponents.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 3/9/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class DetailDisclosureView: UIStackView {
    let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let detailDisclosureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "greaterthan"), for: .normal)
        button.tintColor = .et_textColor5
        button.contentMode = .center
        
        return button
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        
        setupAttributes()
        setupLayout()
        setupConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAttributes() {
        self.axis = .horizontal
        self.distribution = .fillProportionally
    }
    
    private func setupLayout() {
        self.addArrangedSubview(titleLabel)
        self.addArrangedSubview(detailDisclosureButton)
    }
    
    private func setupConstraints() {
        detailDisclosureButton.snp.makeConstraints {
            $0.width.equalTo(15)
        }
    }
}
