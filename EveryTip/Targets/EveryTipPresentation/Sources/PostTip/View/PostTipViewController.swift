//
//  PostTipViewController.swift
//  EveryTip
//
//  Created by 김경록 on 2/22/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class PostTipViewController: UIViewController {
    private let postView = PostTip()
    
    public override func loadView() {
        self.view = postView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        postView.delegate = self
    }
}

extension PostTipViewController: PostViewDelegate {
    func didRequestDismiss(_ Sender: PostTip) {
        self.dismiss(animated: true, completion: nil)
    }
}
