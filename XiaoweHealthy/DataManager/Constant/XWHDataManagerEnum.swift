//
//  XWHDataManagerEnum.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/13.
//

import Foundation


// MARK: - 设备的类别
enum XWHDeviceCategory: String {
    
    case none = ""
    
    // 手表
    case watch
    
}

// MARK: - 设备类型
enum XWHDeviceType: String {
    
    case none = ""
    
    case skyworthWatchS1 = "SKYWORTH Watch S1"
    
    case skyworthWatchS2 = "SKYWORTH Watch S2"
    
}

// MARK: - 运动(Sport)

/// 运动类型
enum XWHSportType {
    
    /// 无类型
    case none
    
    /// 跑步
    case run
    
    /// 走路
    case walk
    
    /// 骑行
    case ride
    
    /// 爬山
    case climb
    
    /// 其他
    case other
    
}

// MARK: - 运动(Sport)

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

