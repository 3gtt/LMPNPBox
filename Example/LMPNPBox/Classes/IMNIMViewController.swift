//
//  IMNIMViewController.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import LMPNPBox

class IMNIMViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datas.removeAll()
        datas.append("\(type(of: self))")
        datas.append("Look at the code")
        
//        // 连接
//        self.imConnection()
//        
//        // 断开
//        self.imDisConnection()
//        
//        // 发送
//        sendData()
//        
//        // 接收数据
//        self.receive()
        
    }
    
    func imConnection() {
        
        // 直接调用SDK
//        let registerConfig = NIMRegistrationConfiguration(
//            appID: "nim appKey",
//            cerName: ""
//        )
//        let loginConfig = NIMLoginConfiguration(
//            id: info.accId,
//            token: info.token
//        )
//        let configuration = NIMConfiguration(
//            registrationConfig: registerConfig,
//            loginConfig: loginConfig
//        )
//        let transport = NIMTransport(configuration: configuration)
//        if LMPNPIMBoxClient.sharedInstance().session?.sessionStatus == .connected {
//            self.disconnect()
//        }
//        LMPNPIMBoxClient.sharedInstance().configureImPlatform(transport: transport)
//        LMPNPIMBoxClient.sharedInstance().connect { [weak self] error in
//        }
        
        // 简单业务封装
        let info = NIMUserInfoModel(
             accId: "",
             token: "",
             appId: "",
             cerName: ""
         ) // 进入该类 查看参数含义
         
         IMMessageManager.shared().connect(
             platform: .nim,
             accId: "",  // 会话Id
             platformInfo: info
         )

    }
    
    func imDisConnection() {
        
        /// 直接调用SDK
//        LMPNPIMBoxClient.sharedInstance().disconnect {[weak self] error in
//        }
        ///简单业务封装
        IMMessageManager.shared().disconnect()
    }
    
    func sendData() {
        
        ///直接调用SDK
//        let messageModel = BaseMessageModel()
//        LMPNPIMBoxClient.sharedInstance().publishData(with: messageModel) { [weak self] (error, msg) in
//        }
        
        
        /// 简单业务封装
        let message = WrapperMessageModel()
        
        IMMessageManager.shared().sender.send(
            destId: "",
            message: message,
            timeoutClosure: { message in
                // 发送超时  原发送消息包原路返回
            },
            completionClosure: { receiptMessageModel in
                // 发送成功 接收回执数据
            }
        )
    }
    
    func receive() {
        
//        /// 添加SDK回调
//        LMPNPIMBoxClient.sharedInstance().subscribe(observer: self)
//        /// 实现 IMSubscribeMessageProtocol 协议 回调
        
        /// 简单的业务封装
        IMMessageManager.shared().receiver.messageReceiverClosure = { message in
            // 返回参数
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
