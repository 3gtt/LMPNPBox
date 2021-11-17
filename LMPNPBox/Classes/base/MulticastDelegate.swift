//
//  MulticastDelegate.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/16.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

open class MulticastDelegate<T>: NSObject {
    
    fileprivate var delegates = [Weak]()
    
    public var isEmpty: Bool {
        return delegates.count == 0
    }
    
    public func add(_ delegate: T) {
        guard !self.contains(delegate) else {
            return
        }
        
        delegates.append(Weak(value: delegate as AnyObject))
    }
    
    public func remove(_ delegate: T) {
        let weak = Weak(value: delegate as AnyObject)
        if let index = delegates.firstIndex(of: weak) {
            delegates.remove(at: index)
        }
    }
    
    /**
     *  这个方法用来触发代理方法
     */
    public func invoke(_ invocation: @escaping (T) -> ()) {
        cleanNullValue()
        delegates.forEach({
            if let delegate = $0.value as? T {
                invocation(delegate)
            }
        })
    }

}

// MARK: private function

extension MulticastDelegate {
    
    private func contains(_ delegate: T) -> Bool {
        return delegates.contains(Weak(value: delegate as AnyObject))
    }
    
    private func cleanNullValue() {
        delegates = delegates.filter{ $0.value != nil }
    }
    
}


/**
 *  自定义操作符实现delegate的添加，同add
 *
 *  - 参数 left:   The multicast delegate
 *  - 参数 right:  The delegate to be added
 */
public func +=<T>(left: MulticastDelegate<T>, right: T) {
    left.add(right)
}

/**
 *  自定义操作符实现delegate的删除，同remove
 *
 *  - 参数 left:   The multicast delegate
 *  - 参数 right:  The delegate to be removed
 */
public func -=<T>(left: MulticastDelegate<T>, right: T) {
    left.remove(right)
}
