//
//  AliYunImSession.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/20.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit
import MQTTClient

class AliyunImSession: BaseSession, IMSessionInitializeProtocol {
    
    typealias Transport = AliyunTransport
    
    public let transport: Transport
    
    private let aliyunSession: MQTTSession
    private let messageQueue: MessageQueue
    
    private var isSubscribing: Bool = false
    private var connectCloser: ((IMError?) -> Void)?
    private var sendMessageThread: DispatchQueue?
     
    required init(_ transport: Transport) {
        self.transport = transport
        self.aliyunSession = MQTTSession()
        self.messageQueue = MessageQueue()
        super.init()
        self.aliyunSession.transport = organizeTransport()
        self.aliyunSession.userName = transport.configuration.username
        self.aliyunSession.password = transport.configuration.password
        self.aliyunSession.clientId = transport.configuration.clientID
        self.aliyunSession.delegate = self
        if !transport.isOpenLogger {
            MQTTLog.setLogLevel(.off)
        }
        doSendMessageTask()
    }
    
    /// 发布消息
    /// - Parameters:
    ///   - data: 消息包 需遵循 IMMessageProtocol
    ///   - completionClosure: 回调
    override func publishData<Data>(
        with data: Data,
        completionClosure: @escaping (IMError?, IMMessageProtocol) -> Void
    ) where Data : IMMessageProtocol {
        let messageWrapperModel = MessageWrapperModel(message: data, completionClosure: completionClosure)
        messageQueue.placeMessage(messageWrapperModel: messageWrapperModel)
    }
    
    /// 发布消息
    /// - Parameters:
    ///   - data: 消息包 Data数据类型
    ///   - destID: 主题 topic
    ///   - completionClosure: 回调
    override func publishData(
        with data: Data,
        destId: String,
        completionClosure: @escaping (IMError?, IMMessageProtocol) -> Void
    ) {
        let model = BaseMessageModel()
        model.destId = destId
        model.content = String(data: data, encoding: String.Encoding.utf8)
        let messageWrapperModel = MessageWrapperModel(message: model, completionClosure: completionClosure)
        messageQueue.placeMessage(messageWrapperModel: messageWrapperModel)
    }
    
    /// 发布消息
    /// - Parameters:
    ///   - dataStr: 字符串形式的消息包
    ///   - destID: 主题 topic
    ///   - completionClosure: 回调
    override func publishData(
        with dataStr: String,
        destId: String,
        completionClosure: @escaping (IMError?, IMMessageProtocol) -> Void
    ) {
        let model = BaseMessageModel()
        model.destId = destId
        model.content = dataStr
        let messageWrapperModel = MessageWrapperModel(message: model, completionClosure: completionClosure)
        messageQueue.placeMessage(messageWrapperModel: messageWrapperModel)
    }
    
    override func connect(completionClosure: @escaping (IMError?) -> Void) {
        aliyunSession.connect()
        connectCloser = completionClosure
    }
    
    override func disconnect(completionClosure: @escaping (IMError?) -> Void) {
        aliyunSession.disconnect()
        completionClosure(nil)
    }
}

// MARK: private function provide
extension AliyunImSession {
    
    private func organizeTransport() -> MQTTCFSocketTransport {
        let transport = MQTTCFSocketTransport()
        transport.host = self.transport.configuration.host
        transport.port = self.transport.configuration.port
        return transport
    }
    
    private func mappingQosLevel(level: IMQosLevel) -> MQTTQosLevel {
        switch level {
        case .leastOnce:
            return .atLeastOnce
        case .mostOnce:
            return .atMostOnce
        case .exactlyOnce:
            return .exactlyOnce
        }
    }
    
    private func mappingQosLevel(qos: MQTTQosLevel) -> IMQosLevel {
        switch qos {
        case .atLeastOnce:
            return .leastOnce
        case .atMostOnce:
            return .mostOnce
        case .exactlyOnce:
            return .exactlyOnce
        default:
            return .leastOnce
        }
    }
    
    private func subscribe() {
        let topic = transport.configuration.topic
        aliyunSession.subscribe(toTopic: topic, at: getQosLevel())
        isSubscribing = true
    }
    
    private func unsubscribe() {
        let topic = transport.configuration.topic
        aliyunSession.unsubscribeTopic(topic)
        isSubscribing = false
    }
    
    private func generatePublishMsgTopic(userId: String) -> String {
        return "\(transport.configuration.topic)\(userId)"
    }
    
    private func getQosLevel() -> MQTTQosLevel {
        let level: IMQosLevel
        if transport.communicationMode == .p2p {
            level = .mostOnce
        } else {
            level = transport.level
        }
        return mappingQosLevel(level: level)
    }
    
    private func doSendMessageTask() {
        if nil == self.sendMessageThread {
            self.sendMessageThread = DispatchQueue(label: "lmpnpbox.mqtt.messager")
        }
        self.sendMessageThread?.async{ [weak self] in
            while true {
                guard let strongSelf = self else { return }
                
                let messageWrapperModel = strongSelf.messageQueue.takeMessage()
                let messageModel = messageWrapperModel.message
                let callback = messageWrapperModel.closure
                
                let level = strongSelf.getQosLevel()
                guard let userId = messageModel.destId else {
                    callback(IMError.destinationIdEmpty, messageModel)
                    return
                }
                let topic = self?.generatePublishMsgTopic(userId: userId)
                guard let data = messageModel.content?.data(using: String.Encoding.utf8) else {
                    callback(IMError.contentEmpty, messageModel)
                    return
                }
                
                if strongSelf.sessionStatus == .connected {
                    strongSelf.aliyunSession.publishData(
                        data,
                        onTopic: topic,
                        retain: strongSelf.transport.isRetain,
                        qos: level
                    )
                    callback(nil, messageModel)
                } else {
                    callback(IMError.connectLost, messageModel)
                }

                let timerInterval = Double(strongSelf.transport.msgTimeIntervalMsec / 1000)
                Thread.sleep(forTimeInterval: timerInterval)
            }
        }
    }
}

// MARK: MQTTSessionDelegate function implemnet

extension AliyunImSession: MQTTSessionDelegate {
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        let connectFailedReason: String
        switch eventCode {
        case .connected:
            connectFailedReason = "connected"
            sessionStatus = .connected
        case .connectionClosed:
            sessionStatus = .disconnected
            connectFailedReason = "connect close"
        case .connectionClosedByBroker:
            if sessionStatus == .connected {
                sessionStatus = .kickout
            } else {
                sessionStatus = .disconnected
            }
            connectFailedReason = "connect by broker"
        case .connectionRefused:
            sessionStatus = .disconnected
            connectFailedReason = "connect refused"
        case .connectionError:
            sessionStatus = .disconnected
            connectFailedReason = error.localizedDescription
        case .protocolError:
            sessionStatus = .disconnected
            connectFailedReason = error.localizedDescription
        default:
            sessionStatus = .disconnected
            connectFailedReason = "unknown error"
        }
        
        if sessionStatus == .connected {
            connectCloser?(nil)
        } else {
            connectCloser?(IMError.connectFailure(message: connectFailedReason))
            messageQueue.clearCache()
        }
        
        multicastDelegate.invoke { [weak self](delegate) in
            guard let strongSelf = self else { return }
            delegate.onSessionStatusChanged(strongSelf.sessionStatus, reason: connectFailedReason)
        }
    }
    
    func newMessage(
        _ session: MQTTSession!,
        data: Data!,
        onTopic topic: String!,
        qos: MQTTQosLevel,
        retained: Bool,
        mid: UInt32
    ) {
        guard let result = String(data: data, encoding: String.Encoding.utf8) else { return }
        multicastDelegate.invoke { (delegate) in
            let model = BaseMessageModel()
            model.content = result
            delegate.onReceiveSubscribe(of: model)
        }
    }
    
}
