//
//  BaseIMMessageModel.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseIMMessageModel:NSObject, Mappable {
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
    }
}
