//
//  IMMessageDefines.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ObjectMapper

/// 消息的类型， 发送接收消息的包装器都是 WrapperMessageModel ，你也可以自定义包装器
/// 所以需要区分是接收还是发送
enum IMMessageType: String {
    
    case send = "sendMessages"
    case receive = "receiveMessages"
    case receipt = "receipt"
    case unknown = "error"
    
    static let transform = TransformOf(
        fromJSON: { IMMessageType(rawValue: $0 ?? "error") },
        toJSON: { $0.map { $0.rawValue } }
    )
    
    /// Follow specific business changes
    /// 根据具体业务改变
    func transformIntValue() -> Int {
        switch self {
        case .send: return 1
        case .receive: return 2
        case .receipt: return 3
        case .unknown: return -100
        }
    }
    
    

}
