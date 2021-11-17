//
//  IMMessageManager.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LMPNPBox


private let instance = IMMessageManager()

class IMMessageManager: NSObject {
    
    let sender: IMMessageSender
    let receiver: IMMessageReceiver
    var currentIMPlatform: IMPlugPlatform = .nim {
        didSet {
            self.sender.currentIMPlatform = currentIMPlatform
            self.receiver.currentIMPlatform = currentIMPlatform
        }
    }
    var status: IMSessionStatus = .disconnected
    var messageHandleQueue: IMMessageHandleQueue
    
    
    override init() {
        self.messageHandleQueue = IMMessageHandleQueue()
        self.sender = IMMessageSender(messageQueue: self.messageHandleQueue)
        self.receiver = IMMessageReceiver(messageQueue: self.messageHandleQueue)
        super.init()
        
    }
    
    static func shared() -> IMMessageManager {
        return instance
    }
    
    func connect(
        platform: IMPlugPlatform,
        accId: String,  
        platformInfo: IMUserInfoProtocol
    ) {
        
        if accId == platformInfo.accId {
            return
        }
        self.currentIMPlatform = platform
        
        switch self.currentIMPlatform {
        case .aliyunMqtt:
            guard let info = platformInfo as? ALMQTTUserInfoModel else {
                return
            }
            connectMQTTPlatform(info: info)
        case .nim:
            guard let info = platformInfo as? NIMUserInfoModel else {
                return
            }
            connectNIMPlatform(info: info)
        case .tim:
            guard let info = platformInfo as? TIMUserInfoModel else {
                return
            }
            connectTIMPlatform(info: info)
            
        default: break
        }
        LMPNPIMBoxClient.sharedInstance().subscribe(observer: self)
        
    }
    
    func disconnect(){
        
        LMPNPIMBoxClient.sharedInstance().disconnect {[weak self] error in
            guard let self = self else { return }
            guard error != nil else {
                print("disconnect success! \(self.currentIMPlatform)")
                return
            }
            print("disconnect failure! \(self.currentIMPlatform)")
            
        }
        
    }

}

extension IMMessageManager {
    
    fileprivate func connectMQTTPlatform(info: ALMQTTUserInfoModel) {
        
        let configuration = AliyunConfiguration(
            host: info.serverUrl,
            port: info.port,  // 端口。
            topic: info.topic,
            clientID: info.accId,
            username: info.userName,
            password: info.password
        )
        let transport = AliyunTransport(
            configuration: configuration,
            level: .mostOnce,
            communicationMode: .p2p,
            isRetain: false,
            isOpenLogger: false
        )
        
        if LMPNPIMBoxClient.sharedInstance().session?.sessionStatus == .connected {
            self.disconnect()
        }
        
        LMPNPIMBoxClient.sharedInstance().configureImPlatform(transport: transport)
        LMPNPIMBoxClient.sharedInstance().connect { [weak self] error in
            guard let self = self else { return }
            guard error != nil else {
                print("connectMQTTPlatform success! --> \(self.currentIMPlatform)")
                return
            }
            print("connectMQTTPlatform failure! --> \(self.currentIMPlatform)")
        }
        
    }
    
    fileprivate func connectNIMPlatform(info: NIMUserInfoModel) {
        
        let registerConfig = NIMRegistrationConfiguration(
            appID: "nim appKey",
            cerName: ""
        )
        let loginConfig = NIMLoginConfiguration(
            id: info.accId,
            token: info.token
        )
        let configuration = NIMConfiguration(
            registrationConfig: registerConfig,
            loginConfig: loginConfig
        )
        let transport = NIMTransport(configuration: configuration)
        if LMPNPIMBoxClient.sharedInstance().session?.sessionStatus == .connected {
            self.disconnect()
        }
        LMPNPIMBoxClient.sharedInstance().configureImPlatform(transport: transport)
        LMPNPIMBoxClient.sharedInstance().connect { [weak self] error in
            guard let self = self else { return }
            guard error != nil else {
                print("connectNIMPlatform success! --> \(self.currentIMPlatform)")
                return
            }
            print("connectNIMPlatform failure! --> \(self.currentIMPlatform)")
        }
        
    }
    
    fileprivate func connectTIMPlatform(info: TIMUserInfoModel) {
        
        let loginConfig = TIMLoginConfiguration(
            id: info.accId,
            token: info.token
        )

        let registerConfig = TIMRegistrationConfiguration(
            sdkAppId: info.appKey
        )
        
        let configuration = TIMConfiguration(
            configuration: registerConfig,
            loginConfig: loginConfig
        )
        
        let transport = TIMTransport(configuration: configuration)
        if LMPNPIMBoxClient.sharedInstance().session?.sessionStatus == .connected {
            self.disconnect()
        }
        LMPNPIMBoxClient.sharedInstance().configureImPlatform(transport: transport)
        LMPNPIMBoxClient.sharedInstance().connect { [weak self] error in
            guard let self = self else { return }
            guard error != nil else {
                print("connectTIMPlatform success! --> \(self.currentIMPlatform)")
                return
            }
            print("connectTIMPlatform failure! --> \(self.currentIMPlatform)")
        }
        
    }
    
}

extension IMMessageManager: IMSubscribeMessageProtocol {
    
    func onSessionStatusChanged(_ status: IMSessionStatus, reason: String){
         
        self.status = status
        print(" onSessionStatusChanged --> \(self.currentIMPlatform), reason = \(reason)")
        
    }
    
    func onReceiveSubscribe<MessageModel: IMMessageProtocol>(of data: MessageModel){
        guard let content = data.content else {
            print("onReceiveSubscribe data.content is nil \(self.currentIMPlatform)")
            return
        }
        guard let model = WrapperMessageModel.init(JSONString: content) else {
            print("onReceiveSubscribe --> \(self.currentIMPlatform) data.content Parse failure！")
            return
        }
        
        #if Debug
        print("onReceiveSubscribe data.content == \(content)")
        #endif
        self.receiver.receive(messageModel: model)
    }
    
}



