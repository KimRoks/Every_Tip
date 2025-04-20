//
//  Character+.swift
//  EveryTipPresentation
//
//  Created by 김경록 on 4/20/25.
//  Copyright © 2025 EveryTip. All rights reserved.
//

import Foundation

extension Character {
    var isKorean: Bool {
        return "\u{AC00}" <= self && self <= "\u{D7A3}"
    }
    
    var isEnglish: Bool {
        return ("a"..."z").contains(self) || ("A"..."Z").contains(self)
    }
}
