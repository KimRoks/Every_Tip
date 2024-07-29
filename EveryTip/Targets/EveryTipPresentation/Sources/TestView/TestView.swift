//
//  TestView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class TestView: UIViewController {
    weak var coordinator: TestViewCoordinator?
    
    var text: String?
    
    init(text: String? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
        print(text)
    }
}
