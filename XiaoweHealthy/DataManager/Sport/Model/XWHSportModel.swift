//
//  XWHSportModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/30.
//

import UIKit
import CoreLocation


/// 运动模型
class XWHSportModel: XWHDataBaseModel {
    
    var uuid = ""
    
    var type: XWHSportType = .none
    var state: XWHSportState = .stop
    
    /// 开始时间
    var bTime = ""
    /// 结束时间
    var eTime = ""
    
    /// 持续时间 (s)
    var duration = 0
    
    /// 步数
    var step = 0
    
    /// 距离 （m）
    var distance = 0
    
    /// 消耗 (KAL)
    var cal = 0
    
    /// 轨迹列表
    var locations: [CLLocation] = []
    
}
