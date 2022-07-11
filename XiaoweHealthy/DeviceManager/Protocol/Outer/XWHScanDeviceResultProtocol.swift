//
//  XWHScanDeviceResultProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/9.
//

import Foundation


protocol XWHScanDeviceResultProtocol: AnyObject {
    
    /// 扫描中
    func deviceScanning(devices: [XWHDevWatchModel])
    
    /// 扫描完成
    func deviceDidScanned(devices: [XWHDevWatchModel])
    
}

extension XWHScanDeviceResultProtocol {
    
    func deviceScanning(devices: [XWHDevWatchModel]) {
        
    }
    
}
