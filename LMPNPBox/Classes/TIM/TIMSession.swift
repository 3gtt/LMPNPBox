//
//  TimSession.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/19.
//  Copyright © 2020 Liam. All rights reserved.
//

import Foundation
import ImSDK

class TIMSession: BaseSession, IMSessionInitializeProtocol {
    
    typealias Transport = TIMTransport
    
    public let transport: Transport
    
    required init(_ transport: Transport) {
        self.transport = transport
        super.init()
        TIMManager.sharedInstance().add(self)
        self.register()
    }
    
    override func connect(completionClosure: @escaping (_ error: IMError?) -> Void) {
        let loginParam = TIMLoginParam()
        loginParam.identifier = self.transport.configuration.loginConfig.id
        loginParam.userSig = self.transport.configuration.loginConfig.token
        
        TIMManager.sharedInstance()?.login(loginParam, succ: {
            completionClosure(nil)
        }, fail: { (code, message) in
            let error = IMError.connectFailure(message: "code = \(code), messsage = \(message ?? "")")
            completionClosure(error)
        })
    }
    
    override func disconnect(completionClosure: @escaping (_ error: IMError?) -> Void) {
        TIMManager.sharedInstance()?.logout({
            completionClosure(nil)
        }, fail: { (code, message) in
            let error = IMError.connectFailure(message: "code = \(code), messsage = \(message ?? "")")
            completionClosure(error)
        })
    }
    
    /// 发布消息
    /// - Parameters:
    ///   - data: 消息包。 data.destId 会话 ID。content 消息内容
    ///           单聊类型（C2C）   ：为对方 userID；
    ///           群组类型（GROUP） ：为群组 groupId；
    ///           系统类型（SYSTEM）：为 @""
    ///   - completionClosure: 发送完成回调
    override func publishData<Data: IMMessageProtocol>(
        with data: Data,
        completionClosure: @escaping (_ error: IMError?, IMMessageProtocol) -> Void)
    {
        guard let content = data.content else {
            completionClosure(IMError.contentEmpty, data)
            return
        }
        guard let id = data.destId, !id.isEmpty else {
            completionClosure(IMError.destinationIdEmpty, data)
            return
        }
        let message = TIMMessage()
        let textElement = TIMTextElem()
        textElement.text = content
        message.add(textElement)
        
        let session = TIMManager.sharedInstance()?.getConversation(.C2C, receiver: id)
        session?.sendOnlineMessage(message, succ: {
            completionClosure(nil, data)
        }, fail: { (code, message) in
            let error = IMError.sendMessageFailure(message: "code = \(code), messsage = \(message ?? "")")
            completionClosure(error, data)
        })
    }
}

// MARK: - private function

extension TIMSession {
    
    private func register() {
        let config = TIMSdkConfig()
        config.sdkAppId = self.transport.configuration.registrationConfig.sdkAppId
        config.disableLogPrint = true
        config.connListener = self
        
        let userConfig = TIMUserConfig()
        userConfig.userStatusListener = self
        
        TIMManager.sharedInstance().initSdk(config)
        TIMManager.sharedInstance().setUserConfig(userConfig)
    }
}

// MARK: - TIM connect callbacks

extension TIMSession: TIMConnListener, TIMUserStatusListener {
    
    func onConnSucc() {
        self.sessionStatus = .connected
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.connected, reason: "connected")
        }
    }
    
    func onDisconnect(_ code: Int32, err: String?) {
        self.sessionStatus = .disconnected
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.disconnected, reason: "disconnected")
        }
    }
    
    func onConnecting() {
         print("Message Channel --> TIM, connecting")
    }
    
    func onConnFailed(_ code: Int32, err: String?) {
        self.sessionStatus = .disconnected
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.disconnected, reason: "disconnected")
        }
        print("Message Channel --> TIM, connect failture")
    }
    
    func onReConnFailed(_ code: Int32, err: String?) {
        self.sessionStatus = .disconnected
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.disconnected, reason: "reconnect failture")
        }
    }
    
    func onForceOffline() {
        self.sessionStatus = .kickout
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.kickout, reason: "kickout")
        }
    }
    
    func onUserSigExpired() {
        self.sessionStatus = .disconnected
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.disconnected, reason: "user signature expired")
        }
    }
}

// MARK: - TIM receive message

extension TIMSession: TIMMessageListener {

    func onNewMessage(_ msgs: [Any]!) {
        let timMessages = msgs as? [TIMMessage] ?? []
        for message in timMessages {
            if message.elemCount() > 0 {
                guard let content = (message.getElem(0) as? TIMTextElem)?.text, !content.isEmpty else {
                    return
                }
                multicastDelegate.invoke { (delegate) in
                    let model = BaseMessageModel()
                    model.content = content
                    delegate.onReceiveSubscribe(of: model)
                }
            }
        }
    }
}
