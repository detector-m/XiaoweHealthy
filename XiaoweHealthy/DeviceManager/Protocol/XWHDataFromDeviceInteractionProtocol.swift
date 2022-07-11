//
//  XWHDataFromDeviceInteractionProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/9.
//

import Foundation


/// 从设备回调的数据交互协议
protocol XWHDataFromDeviceInteractionProtocol: AnyObject {
    
    /// 收到运动状态
    func receiveSportState(_ state: XWHSportState)
    
    /// 收到运动心率
    func receiveSportHeartRate(_ hrs: [XWHHeartModel])
    
}
