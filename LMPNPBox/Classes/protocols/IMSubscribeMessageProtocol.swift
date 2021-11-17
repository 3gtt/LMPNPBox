//
//  IMSubscribeMessageProtocol.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/20.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

public protocol IMSubscribeMessageProtocol: NSObject {
    func onSessionStatusChanged(_ status: IMSessionStatus, reason: String)
    
    func onReceiveSubscribe<MessageModel: IMMessageProtocol>(of data: MessageModel)
}
