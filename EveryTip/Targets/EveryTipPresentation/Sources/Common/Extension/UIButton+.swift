//
//  UIButton+.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 1/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

enum SortOptions {
    case latest
    case views
    case likes
    
    var description: String {
        switch self {
        case .latest:
            return "최신순"
        case .views:
            return "조회순"
        case .likes:
            return "추천순"
        }
    }
}

extension UIButton {
    func configureAttributedForSort(with option: SortOptions) {
        let text = option.description
        let string = text + " "
        let symbol = NSTextAttachment(image: UIImage(systemName: "chevron.down")!)
        symbol.bounds = CGRect(x: 0, y: 0, width: 14, height: 8)

        let symbolString = NSAttributedString(attachment: symbol)

        let attributedString = NSMutableAttributedString(string: string)
        attributedString.append(symbolString)

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.et_textColorBlack10,
            .font: UIFont.et_pretendard(style: .bold, size: 14)
        ]
        
        attributedString.addAttributes(
            attributes,
            range: NSRange(location: 0, length: attributedString.length)
        )

        self.setAttributedTitle(attributedString, for: .normal)
    }
}
