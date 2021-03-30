//
//  Extensions.swift
//  Radio Automne
//
//  Created by Aydar Nasibullin on 26.03.2021.
//  Copyright © 2020-2021 Fetch Development. All rights reserved.
//

import Foundation
extension String {
    var isLatin: Bool {
        let set = "abcdefghijklmnopqrstuvwxyz',.!?- "

        for c in self.map({ String($0) }) {
            if !set.contains(c.lowercased()) {
                return false
            }
        }

        return true
    }

    var isCyrillic: Bool {
        let set = "абвгдежзийклмнопрстуфхцчшщьюя,.!?- "

        for c in self.map({ String($0) }) {
            if !set.contains(c.lowercased()) {
                return false
            }
        }

        return true
    }

    var isBothLatinAndCyrillic: Bool {
        return self.isLatin && self.isCyrillic
    }
}
