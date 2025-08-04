//
//  SetCategoryViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit

import ReactorKit
import RxSwift

final class SetCategoryViewController: BaseViewController {
    
    private var categories: [Constants.Category] = Constants.Category.allCategoriesItems

    weak var coordinator: SetCategoryCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "관심있는 카테고리를 \n선택해주세요"
        label.font = .et_pretendard(
            style: .semiBold,
            size: 22
        )
        label.textColor = .et_textColorBlack90
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text =  "관심있는 카테고리들을 선택하시면 \n관련 팁을 보여드릴게요."
        label.font = .et_pretendard(
            style: .medium,
            size: 14
        )
        label.textColor = .et_textColorBlack30
        
        return label
    }()
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("완료", for: .normal)
        
        button.titleLabel?.font = .et_pretendard(
            style: .bold,
            size: 16
        )
        button.backgroundColor = .et_brandColor2
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        return button
    }()
    
    init(reactor: SetCategoryReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubViews(
            titleLabel,
            subTitleLabel,
            categoriesTableView,
            confirmButton
        )
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(view).offset(20)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalTo(view).offset(20)
        }
        
        categoriesTableView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.bottom.equalTo(confirmButton.snp.top).offset(-40)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.trailing.equalTo(view).inset(20)
            $0.height.equalTo(56)
        }
    }
    
    private func setupTableView() {
        categoriesTableView.dataSource = self
        categoriesTableView.register(
            SetCategoryCell.self,
            forCellReuseIdentifier: SetCategoryCell.reuseIdentifier
        )
        
        categoriesTableView.allowsMultipleSelection = true
        categoriesTableView.separatorStyle = .none
    }
}

extension SetCategoryViewController: View {
    func bind(reactor: SetCategoryReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    func bindInput(reactor: SetCategoryReactor) {
        categoriesTableView.rx.itemSelected
            .map { [weak self] indexPath -> Constants.Category? in
                guard let self = self else { return nil }
                return self.categories[indexPath.row]
            }
            .compactMap { $0 }
            .map { Reactor.Action.toggleCategory($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        categoriesTableView.rx.itemDeselected
            .map { [weak self] indexPath -> Constants.Category? in
                guard let self = self else { return nil }
                return self.categories[indexPath.row]
            }
            .compactMap { $0 }
            .map { Reactor.Action.toggleCategory($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.confirmButtonTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func bindOutput(reactor: SetCategoryReactor) {
        reactor.state
            .map { $0.selectedCategories }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] selected in
                guard let self else { return }
                self.categoriesTableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$toastMessage)
            .subscribe(onNext: { [weak self] message in
                guard let message = message else { return }
                self?.showToast(message: message)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$completedSignal)
            .filter { $0 == true }
            .subscribe(onNext: { [weak self] _ in
                NotificationCenter.default.post(name: .didUpdateUserCategories, object: nil)
                self?.coordinator?.popToRootView()
            })
            .disposed(by: disposeBag)
    }
}

extension SetCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SetCategoryCell.reuseIdentifier, for: indexPath) as? SetCategoryCell else {
            return UITableViewCell()
        }
        
        let item = categories[indexPath.row]
        let isSelected = reactor?.currentState.selectedCategories.contains(where: { $0.id == item.id }) ?? false
        cell.configureCell(with: item, isSelected: isSelected)
        return cell
    }
}
