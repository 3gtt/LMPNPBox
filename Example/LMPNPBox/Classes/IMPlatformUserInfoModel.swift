//
//  IMPlatformAccountInfoModel.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/10.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ObjectMapper

protocol IMUserInfoProtocol {
    var accId: String { get }
    var token: String { get }
}

class TIMUserInfoModel: BaseIMMessageModel, IMUserInfoProtocol {

    /// TIMSDK 登录参数
//    @interface TIMLoginParam : NSObject
//    ///用户名
//    @property(nonatomic,strong) NSString* identifier;
//    ///鉴权 Token
//    @property(nonatomic,strong) NSString* userSig;
//    ///App 用户使用 OAuth 授权体系分配的 Appid
//    @property(nonatomic,strong) NSString* appidAt3rd;
//    @end
    
    var accId: String = ""
    var token: String = ""
    
    /// /// 初始化 SDK 配置信息  注册
    /// @interface TIMSdkConfig : NSObject
    ///用户标识接入 SDK 的应用 ID，必填
    ///@property(nonatomic,assign) int sdkAppId;
    ///
    var appKey: Int32 = 0
    
    init(
        accId: String,
        token: String,
        appKey: Int32
    ) {
        super.init()
        self.accId = accId
        self.token = token
        self.appKey = appKey
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.accId <- map["accId"]
        self.token <- map["token"]
        self.appKey <- map["appKey"]
    }

}
// 网易云信
class NIMUserInfoModel: BaseIMMessageModel, IMUserInfoProtocol {

    
    /*
     - (void)login:(NSString *)account
             token:(NSString *)token
        completion:(NIMLoginHandler)completion;
     accId -> account
     token -> token
     */
    
    // 云信登陆
    var accId: String = ""
    var token: String = ""
    
    /*
     - (void)registerWithAppID:(NSString *)appKey
                       cerName:(nullable NSString *)cerName;
     appId -> appKey
     cerName -> cerName
     */
    // 云信鉴权
    var appId: String = ""
    var cerName: String = ""
    
    init(
        accId: String,
        token: String,
        appId: String,
        cerName: String
    ) {
        super.init()
        self.accId = accId
        self.token = token
        self.appId = appId
        self.cerName = cerName
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.accId <- map["accId"]
        self.token <- map["token"]
    }

}

class ALMQTTUserInfoModel: BaseIMMessageModel, IMUserInfoProtocol {
    
    // 看源代码 MQTT需要的内容
    var serverUrl: String = ""  // host
    var port: UInt32 = 1883
    var topic: String = ""
    var clientId: String = ""
    var userName: String = ""
    var password :String = ""
    
    // MARK -- Differentiated treatment subsequent
    // MARK -- 差异化处理 后续看情况而定
    var accId: String { return self.clientId }
    var token: String { return self.password }
    
    init(
        serverUrl: String,
        port: UInt32,
        topic: String,
        clientId: String,
        userName: String,
        password: String
    ) {
        super.init()
        self.serverUrl = serverUrl
        self.port = port
        self.topic = topic
        self.clientId = clientId
        self.userName = userName
        self.password = password
    }
    
    // MARK -- Mappable
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.serverUrl <- map["serverUrl"]
        self.topic <- map["topic"]
        self.port <- map["port"]
        self.clientId <- map["clientId"]
        self.userName <- map["userName"]
        self.password <- map["password"]
    }
    

    
}
