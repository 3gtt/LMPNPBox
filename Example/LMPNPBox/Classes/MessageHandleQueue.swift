//
//  MessageHandleQueue.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/12.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

typealias MessageTimeoutClosure = (_ message: WrapperMessageModel?) -> Void
typealias MessageCompletionClosure = (_ message: WrapperMessageModel?) -> WrapperMessageModel?

class IMMessageHandleModel {
    
    var message: WrapperMessageModel
    var timeoutClosure: MessageTimeoutClosure?
    var completionClosure: MessageCompletionClosure?
    
    init(
        message: WrapperMessageModel,
        timeoutClosure: MessageTimeoutClosure?,
        completionClosure: MessageCompletionClosure?
    ) {
        self.message = message
        self.timeoutClosure = timeoutClosure
        self.completionClosure = completionClosure
    }
    
}

class IMMessageHandleQueue: NSObject {

    private var messageQueue: [IMMessageHandleModel] = []
    
    var messageIds: [String] {
        return messageQueue.map { $0.message.id }
    }
    
    private let lock = NSRecursiveLock()
    private let sendMessageTimeoutSeconds: TimeInterval = 10
    
    func addMessage(with messageHandle: IMMessageHandleModel) {
        
        lock.lock()
        defer {
            lock.unlock()
        }
        let message = messageHandle.message
        if message.type == .receipt {
            return
        }
        if messageIds.contains(message.id) {
            return
        }
        messageQueue.append(messageHandle)
        
    }
    
    func removeMessage(by messageID: String) {
        lock.lock()
        defer {
            lock.unlock()
        }
        if isContains(of: messageID) {
            messageQueue.removeAll { (model) -> Bool in
                return model.message.id == messageID
            }
            
        }
    }
    
    func removeMessage(by message: WrapperMessageModel) {
        lock.lock()
        defer {
            lock.unlock()
        }
        if isContains(of: message) {
            messageQueue.removeAll { (model) -> Bool in
                return model.message.id == message.id
            }
        }
    }
    
    func selectMessage(by messageID: String) -> IMMessageHandleModel? {
        lock.lock()
        defer {
            lock.unlock()
        }
        guard let index = messageIds.firstIndex(of: messageID) else {
            return nil
        }
        return messageQueue[index]
    }
    
    func isContains(of messageID: String) -> Bool {
        return messageIds.contains(messageID)
    }
    
    func isContains(of message: WrapperMessageModel) -> Bool {
        return messageIds.contains(message.id)
    }
    
    func isContains(of messageHandleModel: IMMessageHandleModel) -> Bool {
        return messageIds.contains(messageHandleModel.message.id)
    }
    

}
