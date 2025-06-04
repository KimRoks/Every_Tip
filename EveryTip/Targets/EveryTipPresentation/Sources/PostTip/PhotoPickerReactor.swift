////
////  PhotoPickerReactor.swift
////  EveryTipPresentation
////
////  Created by 김경록 on 5/2/25.
////  Copyright © 2025 EveryTip. All rights reserved.
////
//
//import Foundation
//
//import EveryTipDomain
//
//import ReactorKit
//import RxSwift
//
//final class PhotoPickerReactor: Reactor {
//    
//    enum PhotoViewType {
//        case main
//        case selected
//    }
//    
//    enum Action {
//        case albumLoad
//        case itemSelected(type: PhotoViewType)
//        case titleTapped(String)
//        case confirmButtonTapped
//        case dismissButtonTapped
//    }
//    
//    enum Mutation {
//        
//    }
//    
//    struct State {
//        var album:
//        var selected:
//        var isThumnail: Bool
//        
//    }
//    
//    var initialState: State
//    
//    init(initialState: State) {
//        self.initialState = initialState
//    }
//    
//    func mutate(action: Action) -> Observable<Mutation> {
//        <#code#>
//    }
//    
//    func reduce(state: State, mutation: Mutation) -> State {
//        <#code#>
//    }
//}
