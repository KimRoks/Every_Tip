//
//  SearchViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/23/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    weak var coordinator: SearchCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
