//
//  PostViewController.swift
//  EveryTip
//
//  Created by 김경록 on 2/22/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

final class PostViewController: UIViewController {
    private let postView = PostView()
    
    public override func loadView() {
        self.view = postView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        postView.delegate = self
    }
}

extension PostViewController: PostViewDelegate {
    func didRequestDismiss(_ Sender: PostView) {
        self.dismiss(animated: true, completion: nil)
    }
}
