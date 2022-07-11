//
//  XWHScanDeviceProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/9.
//

import Foundation

// MARK: - 扫描设备类型
enum XWHScanDeviceType: Int {
    
    // 搜索扫描
    case search
    
    // 扫码扫描
    case qrCode
    
}

protocol XWHScanDeviceProtocol {
    
    /// 扫描超时时间
    var scanTimeout: TimeInterval { get }
    
    /// 扫描类型
    var scanType: XWHScanDeviceType { get }
    
    /// 开始扫描
    /// - Parameters:
    ///     - device: 扫描的设备信息
    ///     - pairMode: .search , .qrCode 必传
    ///     - randomCode: 默认传 空字符串 ""
    ///     - resultDelegate: 回调结果的代理
    func startScanDevice(device: XWHDevWatchModel, scanType: XWHScanDeviceType, randomCode: String, resultDelegate: XWHScanDeviceResultProtocol?)
    
    
    /// 停止扫描
    func stopScanDevice(resultDelegate: XWHScanDeviceResultProtocol?)
    
}
