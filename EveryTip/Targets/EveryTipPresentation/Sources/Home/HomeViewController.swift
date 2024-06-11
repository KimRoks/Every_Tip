//
//  HomeViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/10/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class HomeViewController: BaseViewController {
    
    weak var coordinator: HomeViewCoordinator?
    
    private let viewModel: HomeViewModel
  
    private let disposeBag = DisposeBag()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLogo: UILabel = {
        let label = UILabel()
        label.text = "Every Tip"
        
        return label
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("dd", for: .normal)
        
        return button
    }()
    
    private lazy var topStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        
        return stack
    }()
    
    private let postListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .et_brandColor1
        setupLayout()
        setupConstraints()
        setupTableView()
        bindViewModel()
    }
    
    private func setupLayout() {
        topStackView.addArrangedSubview(titleLogo)
        topStackView.addArrangedSubview(notificationButton)
        
        view.addSubview(topStackView)
        view.addSubview(postListTableView)
    }
    
    private func setupConstraints() {
        topStackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        postListTableView.snp.makeConstraints {
            $0.height.equalTo(view.snp.height).multipliedBy(0.7)
            $0.leading.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        postListTableView.register(PostListCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindViewModel() {
        viewModel.posts.bind(to: postListTableView.rx.items(cellIdentifier: "cell", cellType: PostListCell.self)) { row, data, cell in
            cell.heightAnchor.constraint(equalToConstant: 120).isActive = true
            cell.categoryLabel.text = data.category
            cell.titleLabel.text = data.title
            cell.mainTextView.text = data.mainText
            cell.userNameLabel.text = data.userName
            cell.likeCountLabel.text = "\(data.likeCount)"
            cell.viewCountLabel.text = "\(data.viewCount)"
            // TODO: 이미지 url을 통한 패칭 적용
//            cell.thumbnailImageView.image = UIImage(data: <#T##Data#>)
            
        }.disposed(by: disposeBag)
    }
}
