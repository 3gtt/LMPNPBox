//
//  IMMessageProtocol.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/19.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

/// 消息包通用协议
public protocol IMMessageProtocol: Codable {
    
    /// destId
    ///   TIM 会话Id
    ///     单聊类型（C2C）   ：为对方 userID；
    ///     群组类型（GROUP） ：为群组 groupId；
    ///     系统类型（SYSTEM）：为 @""
    ///   NIM 会话Id
    ///     如果当前session为team,则sessionId为teamId,如果是P2P则为对方帐号 accid
    ///   Aliyun Topic
    var destId: String? { set get }
    
    /// 消息包内容
    var content: String? { set get }

}
