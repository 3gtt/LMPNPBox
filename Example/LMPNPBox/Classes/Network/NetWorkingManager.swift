//
//  NetWorkingManager.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import Alamofire
import LMPNPBox


class NetWorkingManager: NSObject {
    
    private let manager = NetworkReachabilityManager()
    
    static let shared = NetWorkingManager()
    
    var status: NetworkReachabilityManager.NetworkReachabilityStatus {
        return manager?.networkReachabilityStatus ?? .notReachable
    }
    
    private override init() {
        super.init()
        manager?.listener = {[weak self] status in
            guard let self = self else { return }
            // 根据业务进行传值 
        }
        startListeningNetWork()
    }
    
    func startListeningNetWork() {
        manager?.startListening()
    }
    
    func stopListeningNetwork() {
        manager?.stopListening()
    }
}
