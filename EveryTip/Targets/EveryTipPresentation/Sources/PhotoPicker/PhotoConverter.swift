//
//  PhotoConverter.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 6/17/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

import RxSwift
import Photos
import UniformTypeIdentifiers

struct SelectedPhoto {
    let mimeType: String
    let originalData: Data
}

final class PhotoConverter {
    static func convertAssetsToSelectedPhotos(_ assets: [PHAsset]) -> Observable<[SelectedPhoto]> {
        let observables = assets.map { convertSingleAsset($0) }
        return Observable.zip(observables)
            .observe(on: MainScheduler.instance)
    }
    
    private static func convertSingleAsset(_ asset: PHAsset) -> Observable<SelectedPhoto> {
        return Observable.create { observer in
            guard let resource = PHAssetResource.assetResources(for: asset).first else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let uti = resource.uniformTypeIdentifier
            guard let utType = UTType(uti),
                  let mimeType = utType.preferredMIMEType else {
                observer.onCompleted()
                return Disposables.create()
            }
            
            var data = Data()
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true
            
            PHAssetResourceManager.default().requestData(
                for: resource,
                options: options,
                dataReceivedHandler: { chunk in
                    data.append(chunk)
                },
                completionHandler: { error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(
                            SelectedPhoto(
                                mimeType: mimeType,
                                originalData: data
                            )
                        )
                        observer.onCompleted()
                    }
                }
            )
            
            return Disposables.create()
        }
    }
}
