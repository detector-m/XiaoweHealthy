//
//  XWHDevCmdOperationProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/10.
//

import Foundation

typealias XWHDevCmdOperationHandler = ((Result<XWHResponse?, XWHError>) -> Void)


// MARK: - 设备指令操作协议
protocol XWHDevCmdOperationProtocol {
    
    // MARK: - 配置
    
    /// 配置
    /// - Parameter handler: 操作回调结果
    func config(handler: XWHDevCmdOperationHandler?)
    
    // MARK: - 重启/重置
    
    /// 重启设备
    /// - Parameter handler: 操作回调结果
    func reboot(handler: XWHDevCmdOperationHandler?)
    
    /// 重置设备 (恢复出厂设置)
    /// - Parameter handler: 操作回调结果
    func reset(handler: XWHDevCmdOperationHandler?)
    
    // MARK: - 基础指令
    
    /// 设置时间
    /// - Parameter handler: 操作回调结果
    func setTime(handler: XWHDevCmdOperationHandler?)
    
    /// 设置单位
    /// - Parameters:
    ///     - handler: 操作回调结果
    func setUnit(handler: XWHDevCmdOperationHandler?)
    
    /// 设置用户信息
    /// - Parameters:
    ///     - user: 用户信息
    ///     - handler: 操作回调结果
    func setUserInfo(user: XWHUserModel, handler: XWHDevCmdOperationHandler?)
    
}

// MARK: - 默认实现
extension XWHDevCmdOperationProtocol {
    
//    func reboot(handler: XWHDevCmdOperationHandler?) {
//        
//    }
    
}
