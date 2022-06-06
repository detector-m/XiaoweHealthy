//
//  XWHDevDataInteractionProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/6.
//

import Foundation


typealias XWHDevSportModeHandler = (_ mode: XWHSportModeModel) -> Void


/// 设备数据交互（运动处理）协议
protocol XWHDevDataInteractionProtocol {
    
    /// 运动模式
    /// - Parameters:
    ///     - resultHandler: 结果回调
    func getSportMode(_ resultHandler: XWHDevSportModeHandler)    
    
    
}
