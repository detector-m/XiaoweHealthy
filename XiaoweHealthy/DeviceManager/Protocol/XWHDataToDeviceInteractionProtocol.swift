//
//  XWHDevDataInteractionProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/6.
//

import Foundation


/// 设备数据交互（运动处理）协议
protocol XWHDataToDeviceInteractionProtocol {
    
    /// 添加运动的处理回调代理
    func addSportHandlerDelegate(_ fromDelegate: XWHDataFromDeviceInteractionProtocol)
    
    /// 移除运动的处理回调代理
    func removeSportHandlerDelegate()
    
    /// 发送运动模式
    func sendSportState(sportModel: XWHSportModel)
    
    /// 发送运动信息到设备
    func sendSportInfo(_ sportInfo: XWHSportModel)
    
}
