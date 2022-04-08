//
//  XWHBLEDispatchProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation

typealias XWHDevScanProgressHandler = (_ devices: [XWHDevWatchModel]) -> Void

//typealias XWHDevScanHandler = ((_ devices: [XWHDevWatchModel]) -> Void)

typealias XWHDevScanHandler = (Result<[XWHDevWatchModel], XWHBLEError>) -> Void

typealias XWHDevConnectHandler = ((Result<XWHDeviceConnectState, XWHBLEError>) -> Void)

typealias XWHDevBindHandler = ((Result<Bool, XWHBLEError>) -> Void)


protocol XWHBLEDispatchProtocol {
    // MARK: - 基础属性相关
    
    /// 配对方式
    var pairMode: XWHDevicePairMode { get }
    
//    var randomCode: String { get }
    
    /// 连接状态
    var connectState: XWHDeviceConnectState { get }
    
    /// 开始扫描
    /// - Parameters:
    ///     - pairMode: .search , .qrCode 必传
    ///     - randomCode: 默认传 空字符串 ""
    ///     - progressHandler: 扫描进度回调
    ///     - scanHandler: 返回扫描的设备数组 devices[]
    func startScan(pairMode: XWHDevicePairMode, randomCode: String, progressHandler: XWHDevScanProgressHandler?, scanHandler: XWHDevScanHandler?)
    
    
    /// 停止扫描
    func stopScan()
    
    /// 连接设备
    /// - Parameters:
    ///   - device: 需要连接的设备
    ///   - isReconnect: 是否重连
    ///   - connectHandler: 操作结果
    func connect(device: XWHDevWatchModel, isReconnect: Bool, connectHandler: XWHDevConnectHandler?)

    /// 断开连接
    func disconnect(device: XWHDevWatchModel?)
    
    /// 连接超时
    /// - 连接超时处理
    func connectTimeout()
    
    /// 重连设备
    func reconnect(device: XWHDevWatchModel, connectHandler: XWHDevConnectHandler?)
    
    /// 绑定设备
    /// - Parameters:
    ///   - device: 需要绑定的设备
    ///   - completion: 操作结果
    func bind(device: XWHDevWatchModel?, bindHandler: XWHDevBindHandler?)
    
    /// 绑定超时
    /// - 绑定超时处理
    func bindTimeout()
    
    /// 取消配对
    /// - Parameter device: 设备
    func unpair(device: XWHDevWatchModel?)
    
    /// 解除绑定
    func unbind(device: XWHDevWatchModel?, unbindHandler: XWHDevBindHandler?)
    
    /// 切换解绑
    func switchUnbind(handler: XWHDevBindHandler?)
    
    /// 重置代理
//    func resetDelegate()
    
}
