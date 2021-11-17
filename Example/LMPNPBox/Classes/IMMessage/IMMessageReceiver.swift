//
//  IMMessageReceiver.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LMPNPBox

typealias IMMessageReceiverClosure = (_ message: WrapperMessageModel) -> Void

class IMMessageReceiver: NSObject {

    var currentIMPlatform: IMPlugPlatform = .nim
    weak var messageHandleQueue: IMMessageHandleQueue?
    
    var messageReceiverClosure: IMMessageReceiverClosure?
    
    
    init(messageQueue: IMMessageHandleQueue) {
        self.messageHandleQueue = messageQueue
    }
    
    func receive(messageModel: WrapperMessageModel) {
        let id = messageModel.responseID
        if let messageHandleModel = messageHandleQueue?.selectMessage(by: id) {
            _ = messageHandleModel.completionClosure?(messageModel)
        }
        messageHandleQueue?.removeMessage(by: id)
        // 传值功能 看具体业务而定
        messageReceiverClosure?(messageModel)
    }
    
}
