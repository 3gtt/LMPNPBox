//
//  IMTIMViewController.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/14.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class IMTIMViewController: ViewController {

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
        
        /// 直接调用SDK
//        let loginConfig = TIMLoginConfiguration(
//            id: info.accId,
//            token: info.token
//        )
//
//        let registerConfig = TIMRegistrationConfiguration(
//            sdkAppId: info.appKey
//        )
//
//        let configuration = TIMConfiguration(
//            configuration: registerConfig,
//            loginConfig: loginConfig
//        )
//
//        let transport = TIMTransport(configuration: configuration)
        /// 注意： 这里必须断开连接，因为不同平台的session是不同的对象，
        /// 但他们都是同一个session变量
        /// 防止上一个session对象没有断开而直接替换了别的平台的seesion
//        if LMPNPIMBoxClient.sharedInstance().session?.sessionStatus == .connected {
//            self.disconnect()
//        }
//        LMPNPIMBoxClient.sharedInstance().configureImPlatform(transport: transport)
//        LMPNPIMBoxClient.sharedInstance().connect { [weak self] error in
//        }
        
        // 简单业务封装
        let info = TIMUserInfoModel(
            accId: "",
            token: "",
            appKey: 0) // 进入该类 查看参数含义
         
         IMMessageManager.shared().connect(
            platform: .tim,
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
