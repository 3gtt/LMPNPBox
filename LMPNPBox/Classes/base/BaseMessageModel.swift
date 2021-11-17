//
//  BaseReceiveMessageModel.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/16.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

open class BaseMessageModel: IMMessageProtocol {
    
    public var msgID: String  // 消息Id 区分消息 重发时确定是否时某条消息
    
    public var destId: String?
    
    public var content: String?
    
    public init() {
        msgID = UUID().uuidString
    }
    
}
