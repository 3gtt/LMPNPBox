//
//  MessageQueue.swift
//  LMPNPBox
//
//  Created by Liam on 2020/3/26.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

public typealias CompletionClosure = (IMError?, IMMessageProtocol) -> Void

struct MessageWrapperModel {
    
    typealias Message = IMMessageProtocol
    
    let message: Message
    let closure: CompletionClosure
    
    init(message: Message, completionClosure: @escaping CompletionClosure) {
        self.message = message
        self.closure = completionClosure
    }
}

class MessageQueue: NSObject {

    typealias Message = IMMessageProtocol
    
    private var condition: NSCondition?
    private var messageBuffer: [MessageWrapperModel] = []
    
    override init() {
        super.init()
        condition = NSCondition()
        condition?.name = "lmpnpbox.queue.lock"
    }
    
    func placeMessage(messageWrapperModel: MessageWrapperModel) {
        self.condition?.lock()
        defer {
            self.condition?.unlock()
        }
        self.messageBuffer.append(messageWrapperModel)
        self.condition?.signal()
    }
    
    func takeMessage() -> MessageWrapperModel {
        self.condition?.lock()
        while messageBuffer.count <= 0 {
            self.condition?.wait()
        }
        let messageWrapperModel = messageBuffer.remove(at: 0)
        self.condition?.unlock()
        return messageWrapperModel
    }
    
    func clearCache() {
        self.condition?.lock()
        messageBuffer = []
        self.condition?.unlock()
    }
}
