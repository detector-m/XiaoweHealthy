//
//  XWHTimeoutHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation

class XWHTimeoutHandler {
    
    static let kTimeoutTS: TimeInterval = 90
    
    typealias TimeoutTask = (_ cancel: Bool) -> Void
    
    /// 代码延迟运行
    ///
    /// - Parameters:
    ///   - delayTime: 延时时间。比如：.seconds(5)、.milliseconds(500)
    ///   - qosClass: 要使用的全局QOS类（默认为 nil，表示主线程）
    ///   - task: 延迟运行的代码
    /// - Returns: TimeoutTask?
    @discardableResult
    static func delay(by delayTime: TimeInterval, qosClass: DispatchQoS.QoSClass? = nil, _ task: @escaping () -> Void) -> TimeoutTask? {
        
        func dispatch_later(block: @escaping () -> Void) {
            let dispatchQueue = qosClass != nil ? DispatchQueue.global(qos: qosClass!) : .main
            dispatchQueue.asyncAfter(deadline: .now() + delayTime, execute: block)
        }
        
        var closure: (() -> Void)? = task
        var result: TimeoutTask?
        
        let delayedClosure: TimeoutTask = { cancel in
            if let internalClosure = closure {
                if !cancel {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        
        return result
        
    }
    
    /// 取消代码延时运行
    static func delayCancel(_ task: TimeoutTask?) {
        task?(true)
    }
    
}
