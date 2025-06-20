//
//  UserContentsViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 11/18/24.
//  Copyright © 2024 EveryTip. All rights reserved.
//

import UIKit

import EveryTipCore

import SnapKit
final class UserContentsViewController: BaseViewController {
    
    weak var coordinator: UserContentsCoordinator?
    
    private var indicatorLeadingConstraint: Constraint?
    
    private let tabTitles = ["구독자", "구독중", "작성 팁", "저장 팁"]
    
    private var selectedIndex = 0
    
    private let viewControllers: [UIViewController]
                
    private let tabIndicatorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(
            UseContentsCollectionVieweCell.self,
            forCellWithReuseIdentifier: UseContentsCollectionVieweCell.reuseIdentifier
        )
        
        return collectionView
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: "F3F3F3")
        
        return view
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        
        return view
    }()
    
    private let pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        return vc
    }()
    
    init(viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupConstraints()
        setupCollectionView()
        setupPageViewController()
    }
    
    private func setupLayout() {
        view.addSubViews(
            tabIndicatorCollectionView,
            separator,
            indicatorView,
            pageViewController.view
        )
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    private func setupConstraints() {
        tabIndicatorCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        separator.snp.makeConstraints {
            $0.bottom.equalTo(tabIndicatorCollectionView.snp.bottom)
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(view)
        }
        
        indicatorView.snp.makeConstraints {
            $0.bottom.equalTo(tabIndicatorCollectionView.snp.bottom)
            $0.height.equalTo(3)
            $0.width.equalTo(tabIndicatorCollectionView).dividedBy(4)
            self.indicatorLeadingConstraint = $0.leading.equalToSuperview().constraint
        }
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(tabIndicatorCollectionView.snp.bottom).offset(25)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        tabIndicatorCollectionView.delegate = self
        tabIndicatorCollectionView.dataSource = self
    }
    
    private func setupPageViewController() {
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([viewControllers[selectedIndex]], direction: .forward, animated: false)
    }
    
    private func moveIndicator(to index: Int) {
        let cellWidth = tabIndicatorCollectionView.frame.width / 4
        let xOffset = CGFloat(index) * cellWidth
        
        UIView.animate(withDuration: 0.3) {
            self.indicatorLeadingConstraint?.update(offset: xOffset)
            self.view.layoutIfNeeded()
        }
    }
}

extension UserContentsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UseContentsCollectionVieweCell.reuseIdentifier, for: indexPath) as? UseContentsCollectionVieweCell else {
            return UICollectionViewCell()
        }
        let isSelected = indexPath.item == selectedIndex
        cell.setupTitle(tabTitles[indexPath.item], isSelected: isSelected)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != selectedIndex else { return }
        
        let direction: UIPageViewController.NavigationDirection = indexPath.item > selectedIndex ? .forward : .reverse
        
        let previousIndex = selectedIndex
        selectedIndex = indexPath.item
        
        pageViewController.setViewControllers(
            [viewControllers[selectedIndex]],
            direction: direction,
            animated: true
        )
        
        let indexPaths = [IndexPath(item: previousIndex, section: 0),
                          IndexPath(item: selectedIndex, section: 0)]
        collectionView.reloadItems(at: indexPaths)
        moveIndicator(to: selectedIndex)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width / 4
            return CGSize(width: width, height: collectionView.frame.height)
        }
}

extension UserContentsViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource, UICollectionViewDelegateFlowLayout {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index > 0 else { return nil }
        return viewControllers[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllers.firstIndex(of: viewController),
              index < viewControllers.count - 1 else { return nil }
        return viewControllers[index + 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = viewControllers.firstIndex(of: currentVC) else {
            return
        }
        
        let previousIndex = selectedIndex
        selectedIndex = index
        
        let indexPaths = [
            IndexPath(item: previousIndex, section: 0),
            IndexPath(item: selectedIndex, section: 0)
        ]
        tabIndicatorCollectionView.reloadItems(at: indexPaths)
        moveIndicator(to: selectedIndex)
    }
}
