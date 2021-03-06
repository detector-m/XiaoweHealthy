//
//  XWHBLEDispatchProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation


typealias XWHDevScanHandler = (Result<[XWHDevWatchModel], XWHBLEError>) -> Void

typealias XWHDevConnectHandler = ((Result<XWHDeviceConnectBindState, XWHBLEError>) -> Void)

typealias XWHDevBindHandler = XWHDevConnectHandler

/// 监听设备的handler
typealias XWHDeviceMonitorHandler = (XWHDevWatchModel, XWHDeviceConnectBindState) -> Void


protocol XWHBLEDispatchProtocol {
    
    // MARK: - 基础属性相关
    
    /// 连接绑定状态
    var connectBindState: XWHDeviceConnectBindState { get }
    
    /// 指令处理handler
//    var cmdHandler: XWHDevCmdOperationProtocol? { get set }
    
    /// 数据处理handler
//    var dataHandler: XWHDevDataOperationProtocol? { get set }

    
    /// 设置设备连接状态监听回调
    /// - Parameters:
    ///     - device: 设备信息
    ///     - monitorHandler: 设备监听回调
    func setMonitorHandler(device: XWHDevWatchModel?, monitorHandler: XWHDeviceMonitorHandler?)
    
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
