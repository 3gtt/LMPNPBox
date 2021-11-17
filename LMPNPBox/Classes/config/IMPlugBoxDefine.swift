//
//  LMPNPBoxDefine.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/19.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

public enum CommunicationMode {
    
    case subscribe
    case p2p
}

public enum IMQosLevel: Int {
    
    case mostOnce = 0
    case leastOnce = 1
    case exactlyOnce = 2
}

public enum IMPlugPlatform {
    
    case aliyunMqtt // 阿里云 MQTT
    case baiduMqtt  // 百度云 MQTT
    case nim        // 网易云信
    case tim        // 腾讯云通信
}

public enum IMSessionStatus {
    
    case connected
    case disconnected
    case kickout
    
}
