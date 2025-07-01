//
//  UIViewController+.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/26/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSortAlert(handler: @escaping (SortOptions) -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let actions: [(String, SortOptions)] = [
            ("최신순", .latest),
            ("조회순", .views),
            ("추천순", .likes)
        ]
        
        actions.forEach { title, option in
            let action = UIAlertAction(title: title, style: .default) { _ in
                handler(option)
            }
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alertController, animated: true)
    }
}
