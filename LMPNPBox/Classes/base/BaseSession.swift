//
//  BaseSession.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/20.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

public class BaseSession: NSObject, IMSessionProtocol {

    open var sessionStatus: IMSessionStatus = .disconnected
    open var multicastDelegate = MulticastDelegate<IMSubscribeMessageProtocol>()
    
    // MARK: need subclass to implement
    
    override init() {
        super.init()
    }
    
    public func connect(completionClosure: @escaping (IMError?) -> Void) {
        
    }
    
    public func disconnect(completionClosure: @escaping (IMError?) -> Void) {
        
    }
    
    public func subscribe<MessageObserver>(observer obj: MessageObserver) where MessageObserver : IMSubscribeMessageProtocol {
        multicastDelegate += obj
    }
    
    public func unsubscribe<MessageObserver>(observer obj: MessageObserver) where MessageObserver : IMSubscribeMessageProtocol {
        multicastDelegate -= obj
    }

    public func publishData<Data>(with data: Data, completionClosure: @escaping (IMError?, IMMessageProtocol) -> Void) where Data : IMMessageProtocol {
        
    }
    
    func publishData(with data: Data, destId: String, completionClosure: @escaping (IMError?, IMMessageProtocol) -> Void) {
        
    }
    
    func publishData(with dataStr: String, destId: String, completionClosure: @escaping (IMError?, IMMessageProtocol) -> Void) {
        
    }
}
