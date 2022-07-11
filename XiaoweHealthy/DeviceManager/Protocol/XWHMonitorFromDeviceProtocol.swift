//
//  XWHMonitorFromDeviceProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/9.
//

import Foundation
import CoreBluetooth

/// 从设备监听设备协议
protocol XWHMonitorFromDeviceProtocol: AnyObject {
    
    /// 监听手机蓝牙状态
    func receiveBLEState(_ state: CBManagerState)
    
    /// 监听设备的连接信息
    func receiveConnectInfo(device: XWHDevWatchModel, connectState: XWHDeviceConnectBindState, error: XWHBLEError?)
    
    /// 监听同步数据的状态和进度
    func receiveSyncDataStateInfo(syncState: XWHDevDataTransferState, progress: Int, error: XWHError?)
    
}

extension XWHMonitorFromDeviceProtocol {
    
    /// 监听同步数据的状态和进度
    func receiveSyncDataStateInfo(syncState: XWHDevDataTransferState, progress: Int, error: XWHError?) {
        
    }
    
}
