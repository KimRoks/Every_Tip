//
//  PhotoPickerViewController.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/4/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import UIKit
import Photos
import SnapKit

class PhotoPickerViewController: UIViewController {
    
    weak var coordinator: PhotoPickerCoordinator?
    private var selectedAssets: [PHAsset] = []
    // PhotoKit의 PHFetchResult를 통해 사용자의 사진 자산을 저장
    private var album: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    private var userAlbums: [PHAssetCollection] = []

    // PHCachingImageManager 사용하면 캐싱 효과 있음
    private let imageManager = PHCachingImageManager()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(
            UIImage(systemName: "x.square"),
            for: .normal
        )
        button.tintColor = .black
        
        return button
    }()
    
    private let albumPickerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("앨범 선택", for: .normal)
        
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("등록", for: .normal)
        
        return button
    }()
    
    private let photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        let columns: CGFloat = 3
        let sideInset: CGFloat = 5
        let totalSpacing = (columns - 1) * spacing + (sideInset * 2)
        let itemSize = (UIScreen.main.bounds.width - totalSpacing) / columns
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private let separator: StraightLineView = {
        let view = StraightLineView(color: .et_lineGray40)
        
        return view
    }()
    
    private let selectedPhotoView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let selectedPhotoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 13
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        return collectionView
    }()
    
    private let selectedPhotoZoneView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .white
        
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        setupConstraints()
        setupPhotoCollectionView()
        fetchAlbum()
        checkPhotoLibraryPermission()
        setupSelectedPhotoCollectionView()
        albumPickerButton.addTarget(
            self,
            action: #selector(albumPickerButtonTapped),
            for: .touchUpInside
        )
    }
    
    private func setupLayout() {
        view.addSubViews(
            closeButton,
            albumPickerButton,
            registerButton,
            photosCollectionView,
            selectedPhotoView,
            separator
        )
        selectedPhotoView.addSubview(selectedPhotoCollectionView)
    }
    
    private func setupConstraints() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        albumPickerButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.centerX.equalTo(view.snp.centerX)
        }
        
        registerButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        photosCollectionView.snp.makeConstraints {
            $0.top.equalTo(registerButton.snp.bottom).offset(15)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
        separator.snp.makeConstraints {
            $0.top.equalTo(photosCollectionView.snp.bottom)
            $0.leading.trailing.equalTo(view)
        }
        
        selectedPhotoView.snp.makeConstraints {
            $0.top.equalTo(photosCollectionView.snp.bottom)
            $0.leading.trailing.equalTo(view)
            $0.bottom.equalTo(view.snp.bottom)
        }
        
        selectedPhotoCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(selectedPhotoView).inset(10)
            $0.leading.trailing.equalTo(selectedPhotoView).inset(20)
        }
    }
    
    private func setupPhotoCollectionView() {
        photosCollectionView.register(
            PhotoCell.self,
            forCellWithReuseIdentifier: PhotoCell.reuseIdentifier
        )
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        photosCollectionView.allowsMultipleSelection = true
    }
    
    private func setupSelectedPhotoCollectionView() {
        selectedPhotoCollectionView.register(
            SelectedPhotoCell.self,
            forCellWithReuseIdentifier: SelectedPhotoCell.reuseIdentifier
        )
        selectedPhotoCollectionView.delegate = self
        selectedPhotoCollectionView.dataSource = self
    }
    private func fetchUserAlbums() {
        userAlbums.removeAll()
        
        // 사용자가 생성한 앨범
        let userAlbumsFetch = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        userAlbumsFetch.enumerateObjects { collection, _, _ in
            self.userAlbums.append(collection)
        }
        
        // 스마트 앨범 (필요하다면)
        let smartAlbumsFetch = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        smartAlbumsFetch.enumerateObjects { collection, _, _ in
            self.userAlbums.append(collection)
        }
    }
    
    @objc
    private func albumPickerButtonTapped() {
        let alert = UIAlertController(title: "앨범 선택", message: nil, preferredStyle: .actionSheet)
        
        let allAlbumsAction = UIAlertAction(title: "전체", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let options = PHFetchOptions()
            options.includeHiddenAssets = false
            options.includeAssetSourceTypes = [.typeUserLibrary]
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            self.album = PHAsset.fetchAssets(with: .image, options: options)
            self.albumPickerButton.setTitle("전체", for: .normal)
            
            // 기존 선택된 사진 배열 초기화
            self.selectedAssets.removeAll()
            self.photosCollectionView.reloadData()
            self.selectedPhotoCollectionView.reloadData()
        }
        alert.addAction(allAlbumsAction)
        // userAlbums 배열에 있는 앨범들을 액션으로 추가
        for album in userAlbums {
            let title = album.localizedTitle ?? "앨범"
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                guard let self = self else { return }
                // 선택한 앨범의 자산을 fetch
                let options = PHFetchOptions()
                options.includeHiddenAssets = false
                options.includeAssetSourceTypes = [.typeUserLibrary]
                options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                self.album = PHAsset.fetchAssets(in: album, options: options)
                albumPickerButton.setTitle(album.localizedTitle, for: .normal)

                // 선택된 앨범으로 변경되었으므로 기존 선택된 사진 배열 초기화
                self.selectedAssets.removeAll()
                self.photosCollectionView.reloadData()
                self.selectedPhotoCollectionView.reloadData()
            }
            alert.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = albumPickerButton
            popover.sourceRect = albumPickerButton.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }

    private func fetchAlbum() {
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        options.includeAssetSourceTypes = [.typeUserLibrary]
        options.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false
            )
        ]
        album = PHAsset.fetchAssets(with: .image, options: options)
    }
    
    private func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            fetchUserAlbums()
            fetchAlbum()
            photosCollectionView.reloadData()
            
        case .notDetermined:
            // 사용자가 아직 권한 요청을 보지 않았다면 요청
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self?.fetchAlbum()
                        //권한 인증 후 바로 띄워주기 위함
                        self?.photosCollectionView.reloadData()
                    }
                }
            }
            
        default:
            return
        }
    }
    
    private func updateSelectionNumbers() {
        // 선택된 모든 셀의 번호를 재설정
        for (order, asset) in selectedAssets.enumerated() {
            // album에서 asset의 인덱스를 찾아 indexPath 생성
            let itemIndex = album.index(of: asset)
            let indexPath = IndexPath(item: itemIndex, section: 0)
            if let cell = photosCollectionView.cellForItem(at: indexPath) as? PhotoCell {
                cell.setSelected(index: order + 1, true)
            }
        }
        
        // 선택 해제된 셀의 번호는 숨김 처리
        // visible한 셀 중에서 선택되지 않은 셀을 찾아서 업데이트할 수 있음.
        // 모든 visible 셀을 순회하면서, 만약 해당 asset이 선택 배열에 없으면 해제 처리
        for cell in photosCollectionView.visibleCells {
            if let photoCell = cell as? PhotoCell,
               let indexPath = photosCollectionView.indexPath(for: photoCell) {
                let asset = album.object(at: indexPath.item)
                if !selectedAssets.contains(where: { $0.localIdentifier == asset.localIdentifier }) {
                    photoCell.setSelected(index: 0, false)
                }
            }
        }
        selectedPhotoCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PhotoPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case photosCollectionView:
            return album.count
        case selectedPhotoCollectionView:
            return selectedAssets.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case photosCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PhotoCell.reuseIdentifier,
                for: indexPath
            ) as? PhotoCell else {
                return UICollectionViewCell()
            }
            
            let asset = album.object(at: indexPath.item)
            // 요청 사이즈는 셀 크기에 맞춰서 조정
            let targetSize = CGSize(
                width: cell.bounds.width * UIScreen.main.scale,
                height: cell.bounds.height * UIScreen.main.scale
            )
            let options = PHImageRequestOptions()
            options.deliveryMode = .opportunistic
            options.resizeMode = .fast
            
            // 이미지 요청 (비동기로 처리)
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: options
            ) { image, _ in
                DispatchQueue.main.async {
                    cell.updatePhoto(with: image)
                }
            }
            
            if let index = selectedAssets.firstIndex(
                where: { $0.localIdentifier == asset.localIdentifier }
            ) {
                // 선택된 경우: 번호 표시
                cell.setSelected(index: index + 1, true)
            } else {
                // 선택되지 않은 경우: 숨김 처리
                cell.setSelected(index: 0, false)
            }
            return cell
            
        case selectedPhotoCollectionView:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedPhotoCell.reuseIdentifier,
                for: indexPath
            ) as? SelectedPhotoCell else {
                return UICollectionViewCell()
            }
            
            let asset = selectedAssets[indexPath.item]
            let targetSize = CGSize(
                width: 70 * UIScreen.main.scale,
                height: 70 * UIScreen.main.scale
            )
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.resizeMode = .fast
            options.isNetworkAccessAllowed = true
            
            imageManager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFit,
                options: options
            ) { image, _ in
                DispatchQueue.main.async {
                    cell.updatePhoto(image)
                    
                    if indexPath.item == 0 {
                        cell.setThumnail()
                    } else {
                        cell.clearThumnail()
                    }
                    
                }
            }
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case photosCollectionView:
            let asset = album.object(at: indexPath.item)
            selectedAssets.append(asset)
            updateSelectionNumbers()
    
            print(selectedAssets)
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch collectionView {
        case photosCollectionView:
            let asset = album.object(at: indexPath.item)
            
            if let index = selectedAssets.firstIndex(of: asset) {
                selectedAssets.remove(at: index)
            }
            updateSelectionNumbers()
            
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        switch collectionView {
        case photosCollectionView:
            if let selectedIndexPaths = collectionView.indexPathsForSelectedItems,
               selectedIndexPaths.count >= 4 {
                // 최대 4개를 초과하면 선택되지 않도록 false 반환 (원하면 alert를 띄울 수도 있음)
                return false
            }
            return true
            
        default:
            return false
        }
    }
}
