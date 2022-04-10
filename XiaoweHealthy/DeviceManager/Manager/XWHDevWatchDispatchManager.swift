//
//  XWHDevWatchDispatchManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation
import UIKit


var XWHDDMShared: XWHDevWatchDispatchManager {
    XWHDevWatchDispatchManager.shared
}

/// 此类为XWHDevice 蓝牙相关操作分发中心 - 继承 外设管理 - 外设设置 - 数据接收与发送相关，并分发给不同厂商SDK处理事物
class XWHDevWatchDispatchManager {
    
    //单例初始化
    private static var _shared = XWHDevWatchDispatchManager.init()
    static var shared: XWHDevWatchDispatchManager {
        
        return _shared
    }
    
    private init() {
        
    }
    
    // 核心设备与外设操作
    private var bleHandler: XWHBLEDispatchBaseHandler?
    
    // 设备指令操作
    private var cmdHandler: XWHDevCmdOperationProtocol?
    
    // MARK: - handlers
    /* 简单粗暴，为了减少设备init导致delegate变化 */
    private lazy var _uteBLEHandler = XWHBLEUTEDispatchHandler()
    private lazy var _uteCmdHandler = XWHUTECmdOperationHandler()
    
    // MARK: - 方法
    @discardableResult
    func config(device: XWHDevWatchModel) -> Self {
        switch device.type {
        case .none:
            bleHandler?.cmdHandler = nil
            bleHandler = nil
            cmdHandler = nil
            
        case .skyworthWatchS1, .skyworthWatchS2:
            bleHandler = _uteBLEHandler
            cmdHandler = _uteCmdHandler
            bleHandler?.cmdHandler = cmdHandler
            
        }
        return self
    }
    
}

// MARK: - XWHBLEDispatchProtocol(设备连接相关)
extension XWHDevWatchDispatchManager: XWHBLEDispatchProtocol {
    
    /// 配对方式
    var pairMode: XWHDevicePairMode {
        bleHandler?.pairMode ?? .search
    }
    
//    var randomCode: String { get }
    
    /// 连接状态
    var connectState: XWHDeviceConnectState {
        bleHandler?.connectState ?? .disconnected
    }
    
    // MARK: - 扫描
    // 开始扫描
    func startScan(pairMode: XWHDevicePairMode = .search, randomCode: String = "", progressHandler: XWHDevScanProgressHandler? = nil, scanHandler: XWHDevScanHandler?) {
        //调用startScan方法
        //等待各类 处理扫描到的devices后，回调block
        //后 返回给最上层device[]
//        bleHandler?.startScan(pairMode: pairMode, randomCode: randomCode, scanHandler)
        bleHandler?.startScan(pairMode: pairMode, randomCode: randomCode, progressHandler: progressHandler, scanHandler: scanHandler)
    }
  
    // 停止扫描
    func stopScan() {
        bleHandler?.stopScan()
    }
    
    // MARK: - 连接
    func connect(device: XWHDevWatchModel, isReconnect: Bool, connectHandler: XWHDevConnectHandler?) {
        bleHandler?.connect(device: device, isReconnect: isReconnect, connectHandler: connectHandler)
    }

    /// 断开连接
    func disconnect(device: XWHDevWatchModel?) {
        bleHandler?.disconnect(device: device)
    }
    
    /// 连接超时
    /// - 连接超时处理
    func connectTimeout() {
        bleHandler?.connectTimeout()
    }
    
    /// 重连设备
    func reconnect(device: XWHDevWatchModel, connectHandler: XWHDevConnectHandler?) {
        bleHandler?.reconnect(device: device, connectHandler: connectHandler)
    }
    
    // MARK: - 绑定
    func bind(device: XWHDevWatchModel?, bindHandler: XWHDevBindHandler?) {
        bleHandler?.bind(device: device, bindHandler: bindHandler)
    }
    
    /// 绑定超时
    /// - 绑定超时处理
    func bindTimeout() {
        bleHandler?.bindTimeout()
    }
    
    // 取消配对
    func unpair(device: XWHDevWatchModel?) {
        bleHandler?.unpair(device: device)
    }
    
    /// 解除绑定
    func unbind(device: XWHDevWatchModel?, unbindHandler: XWHDevBindHandler?) {
        bleHandler?.unbind(device: device, unbindHandler: unbindHandler)
    }
    
    /// 切换解绑
    func switchUnbind(handler: XWHDevBindHandler?) {
        bleHandler?.switchUnbind(handler: handler)
    }
    
}


// MARK: - XWHDevCmdOperationProtocol(设备指令相关)
extension XWHDevWatchDispatchManager: XWHDevCmdOperationProtocol {
    
    func config(handler: XWHDevCmdOperationHandler? = nil) {
        cmdHandler?.config(handler: handler)
    }
    
    func reboot(handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.reboot(handler: handler)
    }
    
    func reset(handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.reset(handler: handler)
    }
    
    func setTime(handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setTime(handler: handler)
    }
    
    func setUnit(handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setUnit(handler: handler)
    }
    
    func setUserInfo(user: XWHUserModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setUserInfo(user: user, handler: handler)
    }
    
    // MARK: - 获取设备信息
    func getDeviceInfo(handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.getDeviceInfo(handler: handler)
    }
    
}
