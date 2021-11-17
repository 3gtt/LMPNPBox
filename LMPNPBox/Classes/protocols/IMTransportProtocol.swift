//
//  IMTransportProtocol.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/19.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit


public protocol IMTransportProtocol {
    
    associatedtype Configurations: IMConfigurationProtocol
    
    var configuration: Configurations { get set }
    
    func getIMPlugPlatform() -> IMPlugPlatform
    
}
