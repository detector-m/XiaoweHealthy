//
//  XWHDeviceManagerEnum.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation

// MARK: - 设备连接绑定状态
enum XWHDeviceConnectBindState {
    
    /// 断开连接
    case disconnected
    
    /// 连接中
    case connecting
    
    /// 已连接
    case connected
    
    /// 配对中
    case pairing
    
    /// 配对完成
    case paired
    
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

// MARK: - 设备数据传输进度状态
enum XWHDevDataTransferState: Error {
    
    /// 传输失败
    case failed
    
    /// 传输成功
    case succeed
    
    /// 传输中
    case inTransit
    
}

// MARK: - 数据同步
/// 设备同步数据的类型
enum XWHDevSyncDataType: String {
    
    /// none
    case none
    
    /// 心率
    case heart
    
    /// 血氧
    case bloodOxygen
    
    /// 睡眠
    case sleep
    
    /// 精神状态
    case mental
    
    /// 活动
    case activity
    
}


// MARK: - 运动(Sport)

/// 运动类型
enum XWHSportType {
    
    /// none
    case none
    
}

/// 运动状态
enum XWHSportState {
    
    /// 停止
    case stop
    
    /// 开始
    case start
    
    /// 暂停
    case pause
    
    /// 继续
    case  `continue`
    
}
