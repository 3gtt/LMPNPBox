//
//  NIMLiteSession.swift
//  LMPNPBox
//
//  Created by Liam on 2020/9/10.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit
import NIMSDK

class NIMLiteSession: BaseSession, IMSessionInitializeProtocol {

    typealias Transport = NIMTransport
    
    public let transport: Transport
    
    required init(_ transport: NIMTransport) {
        self.transport = transport
        super.init()
        NIMSDK.shared().chatManager.add(self)
        NIMSDK.shared().loginManager.add(self)
        NIMSDK.shared().systemNotificationManager.add(self)
        self.registerSDK()
    }
    
    override func connect(completionClosure: @escaping (IMError?) -> Void) {
        let account = self.transport.configuration.loginConfig.id
        let token = self.transport.configuration.loginConfig.token
        NIMSDK.shared().loginManager.login(account, token: token) { (error) in
            if nil != error {
                completionClosure(IMError.connectFailure(message: error?.localizedDescription ?? "Unknown"))
            } else {
                completionClosure(nil)
            }
        }
    }
    
    override func disconnect(completionClosure: @escaping (IMError?) -> Void) {
        NIMSDK.shared().loginManager.logout { (error) in
            if nil != error {
                completionClosure(IMError.connectFailure(message: error?.localizedDescription ?? "Unknown"))
            } else {
                completionClosure(nil)
            }
        }
    }
    
    /// 发布消息
    /// - Parameters:
    ///   - data: 消息包 data.desId  会话ID,如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号 accid
    ///   - completionClosure: 回调
    override func publishData<Data: IMMessageProtocol>(
        with data: Data,
        completionClosure: @escaping (_ error: IMError?, _ sendMessageModel: IMMessageProtocol) -> Void
    ) {
        guard let content = data.content else {
            completionClosure(IMError.contentEmpty, data)
            return
        }
        guard let id = data.destId, !id.isEmpty else {
            completionClosure(IMError.destinationIdEmpty, data)
            return
        }
        
        let session = NIMSession(id, type: .P2P)
        let notification = NIMCustomSystemNotification(content: content)
        NIMSDK.shared().systemNotificationManager.sendCustomNotification(notification, to: session) { (error) in
            let err: IMError?
            if nil != error {
                err = IMError.sendMessageFailure(message: error?.localizedDescription ?? "Unknown")
            } else {
                err = nil
            }
            completionClosure(err, data)
        }
    }
}

// MARK: private function
extension NIMLiteSession {
    
    private func registerSDK() {
        let appID = transport.configuration.registrationConfig.appID
        let cerName = transport.configuration.registrationConfig.cerName
        NIMSDK.shared().register(withAppID: appID, cerName: cerName)
    }
    
}


// MARK: - NIM receive message and notification
extension NIMLiteSession: NIMChatManagerDelegate, NIMSystemNotificationManagerDelegate {
    
    func onRecvMessages(_ messages: [NIMMessage]) {
        messages
            .filter {$0.messageType == .text}
            .map { $0.text }
            .forEach({ [weak self] (content) in
                self?.multicastDelegate.invoke({ (delegate) in
                    let model = BaseMessageModel()
                    model.content = content
                    delegate.onReceiveSubscribe(of: model)
                })
            })
    }
    
    
    func onReceive(_ notification: NIMCustomSystemNotification) {
        self.multicastDelegate.invoke { (delegate) in
            let model = BaseMessageModel()
            model.content = notification.content
            delegate.onReceiveSubscribe(of: model)
        }
    }
}

// MARK: - NIM login callback
extension NIMLiteSession: NIMLoginManagerDelegate {
    
    func onLogin(_ step: NIMLoginStep) {
        if step == .loginOK {
            self.sessionStatus = .connected
            self.multicastDelegate.invoke { (delegate) in
                delegate.onSessionStatusChanged(.connected, reason: "connected")
            }
        } else if step == .loseConnection {
            self.sessionStatus = .disconnected
            self.multicastDelegate.invoke { (delegate) in
                delegate.onSessionStatusChanged(.disconnected, reason: "disconnected")
            }
        }
        print("Message Channel --> NIM, login step = \(step.rawValue).")
    }
    
    func onKick(_ code: NIMKickReason, clientType: NIMLoginClientType) {
        self.sessionStatus = .kickout
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.kickout, reason: "kickout")
        }
    }
    
    func onMultiLoginClientsChanged() {
         print("Message Channel --> NIM, multiple clients login status changed")
    }
    
    func onAutoLoginFailed(_ error: Error) {
        print("Message Channel --> NIM, automatic login failed")
        self.sessionStatus = .disconnected
        self.multicastDelegate.invoke { (delegate) in
            delegate.onSessionStatusChanged(.disconnected, reason: "disconnected")
        }
    }
    
}
