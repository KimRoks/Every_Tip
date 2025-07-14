//
//  PhotoDetailViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 7/11/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit

import SnapKit
import Kingfisher

final class PhotoDetailViewController: BaseViewController {
    
    private var imageURLs: [String]
    private var startIndex: Int
    
    weak var coordinator: PhotoDetailCoordinator?
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = .black
        
        return collectionView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.et_getImage(for: .closeButton), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    init(imageURLs: [String], startIndex: Int) {
        self.imageURLs = imageURLs
        self.startIndex = startIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        setupLayout()
        setupConstraints()
        setupInitialPage()
        setupCollectionView()
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
    }
    
    private func setupLayout() {
        view.addSubViews(
            photoCollectionView,
            closeButton
        )
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalTo(view.snp.leading).offset(20)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            
            
        }
    }
    
    private func setupCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(
            PhotoDetailCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotoDetailCollectionViewCell.reuseIdentifier
        )
    }
    
    @objc
    private func closeButtonTapped() {
        coordinator?.dismiss()
    }
    
    private func setupInitialPage() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let indexPath = IndexPath(item: self.startIndex, section: 0)
            self.photoCollectionView.scrollToItem(
                at: indexPath,
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
}

extension PhotoDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return imageURLs.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotoDetailCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? PhotoDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURLs[indexPath.item])
        return cell
    }
}

extension PhotoDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }
}
