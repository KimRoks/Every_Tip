//
//  TestView.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDomain

import SnapKit

final class TestView: UIViewController {
    weak var coordinator: TestViewCoordinator?
    
    var tip: Tip?
    
    private let searchStyleNavigationView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private let recentSearchView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let searchTextFieldView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.backgroundColor = .et_lineGray20
        
        return view
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "어떤 팁이 궁금하세요?"
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.et_getImage(for: .searchIcon), for: .normal)
        button.tintColor = .et_brandColor2
        
        return button
    }()
    
    private let manageRecentSearchView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let recentSearchLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.font = .et_pretendard(style: .medium, size: 16)
        
        return label
    }()
    
    private let removeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 삭제", for: .normal)
        button.titleLabel?.font = .et_pretendard(style: .medium, size: 16)
        
        button.tintColor = .et_textColorBlack10
        
        return button
    }()
    
    private let recentSearchTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    init(tip: Tip?) {
        super.init(nibName: nil, bundle: nil)
        self.tip = tip
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupLayout()
        setupconstraints()
        self.navigationController?.isNavigationBarHidden = true
        setupTableView()
//        changeView()
        
        view.backgroundColor = .white
        print(tip!)
    }
    
    private func setupTableView() {
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        recentSearchTableView.register(
            RecentCell.self,
            forCellReuseIdentifier: RecentCell.reuseIdentifier
        )
        
        recentSearchTableView.rowHeight = UITableView.automaticDimension
        recentSearchTableView.separatorStyle = .none
    }
    
    private func setupLayout() {
        searchStyleNavigationView.addSubViews(
            previousButton,
            searchTextFieldView,
            searchButton
        )
        
        manageRecentSearchView.addSubViews(
            recentSearchLabel,
            removeAllButton
        )
        
        recentSearchView.addSubViews(
            manageRecentSearchView,
            recentSearchTableView
        )
        
        view.addSubViews(
            searchStyleNavigationView,
            recentSearchView
        )
        
        searchTextFieldView.addSubview(searchTextField)
    }
    
    private func setupconstraints() {
        
        searchStyleNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        previousButton.snp.makeConstraints {
            $0.centerY.equalTo(searchStyleNavigationView.snp.centerY)
            $0.leading.equalTo(searchStyleNavigationView.snp.leading).offset(20)
        }
        
        searchTextFieldView.snp.makeConstraints {
            $0.top.bottom.equalTo(searchStyleNavigationView).inset(10)
            $0.leading.equalTo(searchStyleNavigationView.snp.leading).offset(45)
            $0.trailing.equalTo(searchStyleNavigationView.snp.trailing).offset(-65)
        }
        
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalTo(searchTextFieldView)
            $0.leading.equalTo(searchTextFieldView).offset(20)
            $0.trailing.equalTo(searchTextFieldView.snp.trailing).offset(-10)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(searchStyleNavigationView.snp.centerY)
            $0.trailing.equalTo(searchStyleNavigationView.snp.trailing).offset(-20)
        }
        
        recentSearchView.snp.makeConstraints {
            $0.top.equalTo(searchStyleNavigationView.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        manageRecentSearchView.snp.makeConstraints {
            $0.top.equalTo(recentSearchView.snp.top)
            $0.leading.trailing.equalTo(recentSearchView)
            $0.height.equalTo(recentSearchLabel.snp.height)
        }
        
        recentSearchLabel.snp.makeConstraints {
            $0.centerY.equalTo(manageRecentSearchView.snp.centerY)
            $0.leading.equalTo(manageRecentSearchView.snp.leading).offset(20)
        }
        
        removeAllButton.snp.makeConstraints {
            $0.centerY.equalTo(manageRecentSearchView.snp.centerY)
            $0.trailing.equalTo(manageRecentSearchView.snp.trailing).offset(-20)
        }
        
        recentSearchTableView.snp.makeConstraints {
            $0.top.equalTo(manageRecentSearchView.snp.bottom).offset(24)
            $0.leading.trailing.equalTo(recentSearchView)
            $0.bottom.equalTo(recentSearchView)
        }
    }
}


extension TestView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentCell.reuseIdentifier, for: indexPath) as? RecentCell else { return UITableViewCell() }
        
        cell.configureCell(text: "dwenrjwenj")
        cell.selectionStyle = .none

        return cell
    }
}
