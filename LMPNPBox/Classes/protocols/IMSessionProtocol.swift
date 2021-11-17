//
//  IMSessionProtocol.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/19.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

public protocol IMSessionInitializeProtocol: NSObject {
    associatedtype Transport: IMTransportProtocol
    init(_ transport: Transport)
}

public protocol IMSessionProtocol: NSObject {
    
    func connect(completionClosure: @escaping (_ error: IMError?) -> Void)
    
    func disconnect(completionClosure: @escaping (_ error: IMError?) -> Void)
    
    func subscribe<MessageObserver: IMSubscribeMessageProtocol>(observer obj: MessageObserver)
    
    func unsubscribe<MessageObserver: IMSubscribeMessageProtocol>(observer obj: MessageObserver)
    
    func publishData<Data: IMMessageProtocol>(with data: Data, completionClosure: @escaping (_ error: IMError?, _ sendMessageModel: IMMessageProtocol) -> Void)

}

extension IMSessionProtocol {
    
    func publishData(
        with dataStr: String,
        destId: String,
        completionClosure: @escaping (_ error: IMError?, _ sendMessageModel: IMMessageProtocol) -> Void
    ) {
        // will be implemented
    }
    
    func publishData(
        with data: Data,
        destId: String,
        completionClosure: @escaping (_ error: IMError?, _ sendMessageModel: IMMessageProtocol) -> Void
    ) {
        // will be implemented
    }
}
