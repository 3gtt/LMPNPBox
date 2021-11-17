//
//  IMError.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/14.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

public enum IMError: Error {
    
    case unknown(code: Int, message: String)
    case connectFailure(message: String)
    case connectLost
    case notRegisted  // 未通过IMApp鉴权
    case contentEmpty // 消息体为空
    case destinationIdEmpty // 目标ID未设置
    case sendMessageFailure(message: String)
    // TODO: 根据需求补充
}
