//
//  XWHMonitorToDeviceProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/9.
//

import Foundation


/// 监听设备协议
protocol XWHMonitorToDeviceProtocol: AnyObject {
    
    func addMonitorDelegate(_ monitorDelegate: XWHMonitorFromDeviceProtocol)
    
    func removeMonitorDelegate(_ monitorDelegate: XWHMonitorFromDeviceProtocol)
    
}
