//
//  XWHDeviceConnectProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/9.
//

import Foundation


protocol XWHDeviceConnectProtocol {
    
    // MARK: - 基础属性相关
    /// 连接绑定状态
    var connectBindState: XWHDeviceConnectBindState { get }
    
    /// 连接设备
    /// - Parameters:
    ///   - device: 需要连接的设备
    func connect(device: XWHDevWatchModel)

    /// 断开连接
    func disconnect(device: XWHDevWatchModel)
    
}
