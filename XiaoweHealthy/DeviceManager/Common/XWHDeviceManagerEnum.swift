//
//  XWHDeviceManagerEnum.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation

// MARK: - 设备类型
enum XWHDeviceType: String {
    
    case none = ""
    
    case skyworthWatchS1 = "Skyworth Watch S1"
    
    case skyworthWatchS2 = "Skyworth Watch S2"
    
}

// MARK: - 设备连接状态
enum XWHDeviceConnectState {
    
    /// 已连接
    case connected
    
    /// 连接中
    case connecting
    
    /// 断开连接
    case disconnected
    
}

// MARK: - 设备配对模式
enum XWHDevicePairMode: Int {
    
    // 搜索配对
    case search
    
    // 扫码配对
    case qrCode
    
}

// MARK: - 设备连接配对错误
enum XWHBLEError: Error {
    
    /// 超时失败
    case normal
    
    /// 已被绑定，绑定失败
    case binded
    
    /// 已被重置
    case reset
    
}
