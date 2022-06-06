//
//  XWHSportModeModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/6.
//

import Foundation


/// 运动模式模型
struct XWHSportModeModel {
    
    /// 运动类型
    var type: XWHSportType = .none
    
    /// 运动状态
    var status: XWHSportState = .stop
    
        
    /// 心率的监测时间间隔 (Unit second)
    var hrMonitorTime = 10
    
    /// 持续的时间 （Unit second）
    var duration = 0
    
    /// 卡路里 (Unit kcal)
    var calories = 0
    
    /// 距离 (Unit meter)
    var distance = 0
    
    
    /**
        Required isHasSportPause=YES.
        The activity speed of the device. (Unit second) e.g 430 is 7 minute 10 second per kilometer (7'10")
        If the speed is greater than 6039(99'99"), it will only take the value 6039(99'99").
    */
    
    /// 配速 （Unit second/km）
    var pace = 0
    
    /// 速度 （Unit m/s）
    var speed = 0
    
}
