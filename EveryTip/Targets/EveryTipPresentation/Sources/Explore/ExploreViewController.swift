//
//  ExploreViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/29/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipDesignSystem

import SnapKit
import ReactorKit
import RxCocoa
import RxSwift
import EveryTipDomain

final class ExploreViewController: BaseViewController, View {
    weak var coordinator: ExploreCoordinator?
    var disposeBag: DisposeBag = DisposeBag()
    
    private let roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.setRoundedCorners(
            radius: 15,
            corners: .layerMinXMinYCorner, .layerMaxXMinYCorner
        )
        
        return view
    }()
        
    private let exploreTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.et_pretendard(
            style: .bold,
            size: 18
        )
        
        return label
    }()
    
    private let storyCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(
            width: 90,
            height: 100
        )
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 0
        )
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        collectionView.indicatorStyle = .white
        
        collectionView.register(
            StoryCollectionViewCell.self,
            forCellWithReuseIdentifier: StoryCollectionViewCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    private let sortButton: SortButton = {
        let button = SortButton()
        
        return button
    }()
    
    private let tipListTableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    private let placeholderView: UserContentPlaceholderView = {
        let view = UserContentPlaceholderView(type: .emptyTip)
        view.isHidden = true
        
        return view
    }()
    
    init(reactor: ExploreReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.et_brandColor2
        setupLayout()
        setupConstraints()
        setupTableView()
    }
    
    private func setupLayout() {
        view.addSubview(roundedBackgroundView)
        roundedBackgroundView.addSubViews(
            exploreTitleLabel,
            storyCollectionView,
            sortButton,
            tipListTableView,
            placeholderView
        )
    }
    
    private func setupConstraints() {
        roundedBackgroundView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        }
        
        exploreTitleLabel.snp.makeConstraints {
            $0.top.equalTo(roundedBackgroundView.snp.top).offset(20)
            $0.leading.equalTo(roundedBackgroundView.snp.leading).offset(20)
        }
        
        storyCollectionView.snp.makeConstraints {
            $0.top.equalTo(exploreTitleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalTo(roundedBackgroundView)
            $0.height.equalTo(100)
        }
        
        sortButton.snp.makeConstraints {
            $0.top.equalTo(storyCollectionView.snp.bottom).offset(20)
            $0.trailing.equalTo(roundedBackgroundView.snp.trailing).offset(-20)
        }
        
        tipListTableView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom)
            $0.leading.trailing.equalTo(roundedBackgroundView)
            $0.bottom.equalTo(roundedBackgroundView)
        }
        
        placeholderView.snp.makeConstraints {
            $0.top.equalTo(sortButton.snp.bottom)
            $0.leading.trailing.equalTo(roundedBackgroundView)
            $0.bottom.equalTo(roundedBackgroundView)
        }
    }
    
    private func setupTableView() {
        tipListTableView.register(
            TipListCell.self,
            forCellReuseIdentifier: TipListCell.reuseIdentifier
        )
        tipListTableView.rowHeight = UITableView.automaticDimension
        tipListTableView.estimatedRowHeight = 110
    }

    // MARK: Reactor
    
    func bind(reactor: ExploreReactor) {
        bindInput(to: reactor)
        bindOutput(to: reactor)
    }
    
    private func bindInput(to reactor: ExploreReactor) {
        sortButton.rx.tap
            .subscribe { [weak self] _ in
                self?.presentSortAlert { selectedOption in
                    self?.reactor?.action.onNext(.sortButtonTapped(selectedOption))
                }
            }
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        storyCollectionView.rx.modelSelected(Story.self)
            .map{ story in Reactor.Action.storyCellTapped(selectedStory: story) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tipListTableView.rx.modelSelected(Tip.self)
            .map { Reactor.Action.itemSelected($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindOutput(to reactor: ExploreReactor) {
        reactor.state
            .map { $0.sortOption }
            .distinctUntilChanged()
            .bind { [weak self] sortOption in
                guard let self = self else { return }
                self.sortButton.configureButtonStyle(with: sortOption)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.stories }
            .bind(to: storyCollectionView.rx.items(
                cellIdentifier: StoryCollectionViewCell.reuseIdentifier,
                cellType: StoryCollectionViewCell.self)
            ) { index, data, cell in
                
                if data.type == .everyTip {
                    cell.configureEveryTipCell(
                        userName: "전체팁",
                        image: UIImage.et_getImage(for: .everyTipLogo_story)
                    )
                    
                } else {
                    cell.configureUserTipCell(
                        userName: data.user?.nickName,
                        imageURL: data.user?.profileImageURL
                    )
                }
                
                let isSelected = data.user?.id == reactor.currentState.selectedStory.user?.id
                
                cell.setSelected(isSelected)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.selectedStory }
            .bind { [weak self] selectedStory in
                guard let self = self else { return }
                if selectedStory.type == .everyTip {
                    self.exploreTitleLabel.text = "전체 팁 목록 👀"
                } else {
                    self.exploreTitleLabel.text = "\(selectedStory.user?.nickName ?? "unknown")님 팁 목록 👀"
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.visibleTips }
            .bind(to: tipListTableView.rx.items(
                cellIdentifier: TipListCell.reuseIdentifier,
                cellType: TipListCell.self)
            ) { row, tip, cell in
                cell.configureTipListCell(with: tip)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { !$0.visibleTips.isEmpty }
            .distinctUntilChanged()
            .bind(to: placeholderView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$pushSignal)
            .filter { $0 }
            .withUnretained(self)
            .bind { vc, _ in
                guard let tip = vc.reactor?.currentState.selectedTip else {
                    return
                }
                vc.coordinator?.pushToTipDetailView(with: tip.id)
            }.disposed(by: disposeBag)
    }
}
