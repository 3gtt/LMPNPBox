//
//  AliyunTransport.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/20.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit
import CommonCrypto

public struct AliyunConfiguration: IMConfigurationProtocol {
    
//    var password: String {
//        //username和 Password 签名模式下的设置方法，参考文档 https://help.aliyun.com/document_detail/48271.html?spm=a2c4g.11186623.6.553.217831c3BSFry7
//        var retValue: String = ""
//        guard let saltData = secretKey.data(using: String.Encoding.utf8) else { return retValue }
//        guard let paramData = "\(groupId)@@@\(userId)".data(using: String.Encoding.utf8) else { return retValue }
//        if let mutableData = NSMutableData(length: Int(CC_SHA1_DIGEST_LENGTH)) {
//            saltData.withUnsafeBytes({ (saltBytes) -> Void in
//                paramData.withUnsafeBytes({ (paramBytes) -> Void in
//                    CCHmac(
//                        CCHmacAlgorithm(kCCHmacAlgSHA1),
//                        saltBytes,
//                        saltData.count,
//                        paramBytes,
//                        paramData.count,
//                        mutableData.mutableBytes
//                    )
//                })
//            })
//            retValue = mutableData.base64EncodedString(options: [])
//        }
//        return retValue
//    }
    
    let host: String
    let port: UInt32
    let topic: String               // DEV_LUKA_P2P/p2p/
    let clientID: String
    let username: String
    let password: String
    
    public init(
        host: String,
        port: UInt32,
        topic: String,
        clientID: String,
        username: String,
        password: String
    ) {
        self.host = host
        self.port = port
        self.topic = topic
        self.clientID = clientID
        self.username = username
        self.password = password
    }
    
}

public struct AliyunTransport: IMTransportProtocol {
    
    public typealias Configurations = AliyunConfiguration

    public var configuration: Configurations
    var level: IMQosLevel
    var communicationMode: CommunicationMode
    var isRetain: Bool
    var isOpenLogger: Bool
    var msgTimeIntervalMsec: Int = 100
    
    public init(
        configuration: Configurations,
        level: IMQosLevel,
        communicationMode: CommunicationMode,
        isRetain: Bool,
        isOpenLogger: Bool,
        msgTimeIntervalMsec: Int = 100
    ) {
        self.configuration = configuration
        self.level = level
        self.communicationMode = communicationMode
        self.isRetain = isRetain
        self.isOpenLogger = isOpenLogger
        self.msgTimeIntervalMsec = msgTimeIntervalMsec
    }

    public func getIMPlugPlatform() -> IMPlugPlatform {
        return .aliyunMqtt
    }

}
