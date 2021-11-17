//
//  Weak.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/16.
//  Copyright © 2020 Liam. All rights reserved.
//

import Foundation

class Weak: Equatable {

    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
    
    static func ==(lhs: Weak, rhs: Weak) -> Bool {
        return lhs.value === rhs.value
    }
}
