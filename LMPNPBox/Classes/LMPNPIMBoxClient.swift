//
//  ImPlugBoxClient.swift
//  LMPNPBox
//
//  Created by Liam on 2020/1/21.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

private let instance = LMPNPIMBoxClient()

open class LMPNPIMBoxClient: NSObject, IMSessionProtocol {
    
    public var session: BaseSession?
    
    public static func sharedInstance() -> LMPNPIMBoxClient {
        return instance
    }
    
    public func connect(completionClosure: @escaping (IMError?) -> Void) {
        session?.connect(completionClosure: completionClosure)
    }
    
    public func disconnect(completionClosure: @escaping (IMError?) -> Void) {
        session?.disconnect(completionClosure: completionClosure)
    }
    
    public func subscribe<MessageObserver>(observer obj: MessageObserver) where MessageObserver : IMSubscribeMessageProtocol {
        session?.subscribe(observer: obj)
    }
    
    public func unsubscribe<MessageObserver>(observer obj: MessageObserver) where MessageObserver : IMSubscribeMessageProtocol {
        session?.unsubscribe(observer: obj)
    }
    
    public func publishData<Data>(with data: Data, completionClosure: @escaping (IMError?, IMMessageProtocol) -> Void) where Data : IMMessageProtocol {
        session?.publishData(with: data, completionClosure: completionClosure)
    }
}
