//
//  IMChatMessageModels.swift
//  LMPNPBox_Example
//
//  Created by Liam on 2021/11/8.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import ObjectMapper

class IMTextMessageModels: BaseIMMessageModel {

    var textContent: String = ""
    
    init(textContent: String) {
        super.init()
        self.textContent = textContent
    }
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        textContent <- map["textContent"]
    }
    
}

/// wrap the model that needs to be sent as WrapperMessageModel
/// The actual messages sent are packets wrapped by this object, with different values in each packet
/// 包装器，将需要发送的model 封装成 WrapperMessageModel
/// 实际发送的消息都是此对象包装的 消息包，只不过是每个包中的value不一样
class WrapperMessageModel: BaseIMMessageModel {
    
    /// Message content is tailored to the business
    /// 详细内容根据业务进行定制
    var id: String = ""
    var version: Int = 0
    var timestamp: Int64 = 0
    var responseID: String = ""
    var locale: String = ""
    var type: IMMessageType = .unknown
    var value: [String: Any] = ["": ""] // 消息的具体内容，建议使用json数据
    
}

class IMMessageAttachmentModel: BaseIMMessageModel {

    var type: IMMessageType = .unknown
    var value: [String: Any] = [: ]
    
    init<MessageValueModel: BaseIMMessageModel>(
        type: IMMessageType,
        messageValueModel: MessageValueModel
    ) {
        super.init()
        self.type = type
        self.value = messageValueModel.toJSON()
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        type <- map["type"]
        value <- map["value"]
    }
    
}

class IMReceiptMessageModel: BaseIMMessageModel {
    
    var status: Int = -1
    var message: String = ""
    var attachment: IMMessageAttachmentModel?
    
    init(status: Int, message: String, attachment: IMMessageAttachmentModel? = nil) {
        super.init()
        self.status = status
        self.message = message
        self.attachment = attachment
    }

    required init?(map: Map) {
        super.init(map: map)
    }

    override func mapping(map: Map) {
        super.mapping(map: map)
        status <- map["status"]
        message <- map["message"]
        attachment <- map["attachment"]
    }
    
    var receiptCode: IMMessageReceiptCode {
        switch status {
        case 0:
            return .success
        case -1:
            return .unknown
        case -1001:
            return .networkConnectionLost
        case -900:
            return .timeout
        default:
            return .unknown
        }
    }
    
    
    
}

public enum IMMessageReceiptCode: Int {
    // 根据业务进行调整
    // Adjust according to your business
    case success = 0
    case unknown = -1                   // 接收方不关心的错误或未知错误
    case dormant = -2                   // 正在休眠
    case networkConnectionLost = -1001  // 网络错误
    case timeout = -900                 // APP内自定义
}


/// 分包消息，JSON 串直接截断处理
class SubpackageStringMessageModel: BaseIMMessageModel {
    
    var id: String = ""
    var total: Int = 0
    var index: Int = 0
    var chunk: String = ""
    
    init(id: String, index: Int, total: Int, chunk: String) {
        super.init()
        self.id = id
        self.index = index
        self.total = total
        self.chunk = chunk
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        id <- map["id"]
        total <- map["total"]
        index <- map["index"]
        chunk <- map["chunk"]
    }
}
