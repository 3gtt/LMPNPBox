//
//  IMMessageSender.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LMPNPBox
import Alamofire

/// 根据自身业务做自定义处理

typealias IMSDKCompletionClosure  = (Error?) -> Void
typealias IMReceiptMessageClosure = (IMReceiptMessageModel?) -> Void
private let kTimeoutInterval: TimeInterval = 10

class IMMessageSender: NSObject {

    var currentIMPlatform: IMPlugPlatform = .nim
    weak var messageHandleQueue: IMMessageHandleQueue?
    
    init(messageQueue: IMMessageHandleQueue) {
        self.messageHandleQueue = messageQueue
    }
    
    func send(
        destId: String,
        message: WrapperMessageModel,
        timeoutClosure: MessageTimeoutClosure?,
        completionClosure: IMReceiptMessageClosure?
    ) {
        
        if NetWorkingManager.shared.status == .notReachable {
            let receipt = IMReceiptMessageModel(
                status: IMMessageReceiptCode.networkConnectionLost.rawValue,
                message: "network connection lost"
            )
            completionClosure?(receipt)
            return
        }
        let imSDKCompletionClosure: IMSDKCompletionClosure = { error in
            if nil == error {
                print("IMMessageSender send  \(self.currentIMPlatform) SDK send successs！")
            } else {
                print("IMMessageSender send   \(self.currentIMPlatform) SDK send failure！")
                timeoutClosure?(message)
            }
        }
        
        let imMessageCompletionClosure: MessageCompletionClosure = { message in
            guard let value = message?.value, let receipt = IMReceiptMessageModel(JSON: value) else {
                print("IMMessageSender send --> \(self.currentIMPlatform), 消息回执解析失败~")
                completionClosure?(nil)
                return nil
            }
            completionClosure?(receipt)
            return nil
        }
        
        let isNeedAddMessageQueue = isNeedAddMessageQueue(message: message)
        if currentIMPlatform == .aliyunMqtt {
            sendSinglePacketMessage(
                destId: destId,
                message: message,
                isNeedAddMessageQueue: isNeedAddMessageQueue,
                timeoutClosure: timeoutClosure,
                imSDKCompletionClosure: imSDKCompletionClosure,
                completion: imMessageCompletionClosure
            )
        } else {
            let messageStr = message.toJSONString() ?? ""
            if messageStr.count > 1000 {
                sendMultiplePacketMessage(
                    destId: destId,
                    message: message,
                    timeoutClosure: timeoutClosure,
                    imSDKCompletionClosure: imSDKCompletionClosure,
                    completion: imMessageCompletionClosure
                )
            } else {
                sendSinglePacketMessage(
                    destId: destId,
                    message: message,
                    isNeedAddMessageQueue: isNeedAddMessageQueue,
                    timeoutClosure: timeoutClosure,
                    imSDKCompletionClosure: imSDKCompletionClosure,
                    completion: imMessageCompletionClosure
                )
            }
        }
        
    }
    
    func sendSinglePacketMessage(
        destId: String,
        message: WrapperMessageModel,
        isNeedAddMessageQueue: Bool,
        timeoutClosure: MessageTimeoutClosure?,
        imSDKCompletionClosure: IMSDKCompletionClosure?,
        completion: MessageCompletionClosure?
    ) {
        
        let messageModel = BaseMessageModel()
        messageModel.destId = destId
        messageModel.content = message.toJSONString() ?? ""
        
        #if DEBUG
        print("IMMessageSender sendSinglePacketMessage --> \(self.currentIMPlatform), \(message.toJSONString(prettyPrint: true) ?? "")")
        #endif
        
        LMPNPIMBoxClient.sharedInstance().publishData(with: messageModel) { [weak self] (error, msg) in
            imSDKCompletionClosure?(error)
            if nil == error && isNeedAddMessageQueue {
                let messageHandleModel = IMMessageHandleModel(
                    message: message,
                    timeoutClosure: timeoutClosure,
                    completionClosure: completion
                )
                self?.messageHandleQueue?.addMessage(with: messageHandleModel)
                self?.setupSendMsgTimeoutListenser(with: kTimeoutInterval, messageHandleModel: messageHandleModel)
            }
        }
    }
    
    func sendMultiplePacketMessage(
        destId: String,
        message: WrapperMessageModel,
        timeoutClosure: MessageTimeoutClosure?,
        imSDKCompletionClosure: IMSDKCompletionClosure?,
        completion: MessageCompletionClosure?
    ) {
        let uuid = UUID().uuidString
        let messageStr = message.toJSONString() ?? ""
        let spliteStrArray = messageStr.substrings(sublength: 1000)
        for index in 0..<spliteStrArray.count {
            let messagePacket = SubpackageStringMessageModel(
                id: uuid,
                index: index,
                total: spliteStrArray.count,
                chunk: spliteStrArray[index]
            )
            
            let messageModel = BaseMessageModel()
            messageModel.destId = destId
            messageModel.content = messagePacket.toJSONString() ?? ""
            
            #if DEBUG
            print(
                "IMMessageSender sendMultiplePacketMessage --> \(self.currentIMPlatform), "
                + "message index = \(index), \(messagePacket.toJSONString(prettyPrint: true) ?? "")"
            )
            #endif
            
            LMPNPIMBoxClient.sharedInstance().publishData(with: messageModel) { [weak self] (error, msg) in
                imSDKCompletionClosure?(error)
                if nil == error {
                    let messageHandleModel = IMMessageHandleModel(
                        message: message,
                        timeoutClosure: timeoutClosure,
                        completionClosure: completion
                    )
                    self?.messageHandleQueue?.addMessage(with: messageHandleModel)
                    self?.setupSendMsgTimeoutListenser(with: kTimeoutInterval, messageHandleModel: messageHandleModel)
                }
            }
        }
    }
    
    private func isNeedAddMessageQueue(message: WrapperMessageModel) -> Bool {
        if nil != message.value["chunk_id"] as? String {
            let total = message.value["total"] as? Int ?? -1
            let index = message.value["index"] as? Int ?? -1
            if total != index + 1 {
                return false
            }
        }
        return true
    }
    
    private func setupSendMsgTimeoutListenser(
        with timeoutInterval: TimeInterval,
        messageHandleModel: IMMessageHandleModel
    ) {
        // 如果没有添加到 queue 中，不处理 timeout 逻辑。
        DispatchQueue.main.asyncAfter(deadline: .now() + timeoutInterval) {
            // 超时后发现 message 已经被从 queue 中移除，不处理 timeout 逻辑
            guard let messageHandleQueue = self.messageHandleQueue,
                  messageHandleQueue.isContains(of: messageHandleModel),
                  let timeoutClosure = messageHandleModel.timeoutClosure else { return }
            timeoutClosure(messageHandleModel.message)
        }
    }
    
}


