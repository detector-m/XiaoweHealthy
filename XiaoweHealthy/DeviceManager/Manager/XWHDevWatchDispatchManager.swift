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
    
    // MARK: - 配置
    
    func config(_ user: XWHUserModel? = nil, _ raiseWristSet: XWHRaiseWristSetModel? = nil, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.config(user, raiseWristSet, handler: handler)
    }
    
    // MARK: - 重启/重置
    
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
    
    // 设置用户信息
    func setUserInfo(_ user: XWHUserModel, _ raiseWristSet: XWHRaiseWristSetModel? = nil, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setUserInfo(user, raiseWristSet, handler: handler)
    }
    
    // MARK: - 获取设备信息
    
    func getDeviceInfo(handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.getDeviceInfo(handler: handler)
    }
    
    // MARK: - 设备设置
    
    /// 设置抬腕亮屏
    func setRaiseWristSet(_ raiseWristSet: XWHRaiseWristSetModel, _ user: XWHUserModel? = nil, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setRaiseWristSet(raiseWristSet, user, handler: handler)
    }
    
    // 设置通知设置
    func setNoticeSet(_ noticeSet: XWHNoticeSetModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setNoticeSet(noticeSet, handler: handler)
    }

    // 设置久坐提醒
    func setLongSitSet(_ longSitSet: XWHLongSitSetModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setLongSitSet(longSitSet, handler: handler)
    }
    
    /// 设置血压设置
    func setBloodPressureSet(_ bloodPressureSet: XWHBloodPressureSetModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setBloodPressureSet(bloodPressureSet, handler: handler)
    }
    
    /// 设置血氧设置
    func setBloodOxygenSet(_ bloodOxygenSet: XWHBloodOxygenSetModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setBloodOxygenSet(bloodOxygenSet, handler: handler)
    }
    
    /// 设置心率设置
    func setHeartSet(_ heartSet: XWHHeartSetModel, _ user: XWHUserModel? = nil, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setHeartSet(heartSet, user, handler: handler)
    }
    
    /// 设置勿扰模式设置
    func setDisturbSet(_ disturbSet: XWHDisturbSetModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setDisturbSet(disturbSet, handler: handler)
    }
    
    /// 设置天气
    func setWeatherSet(_ weatherSet: XWHWeatherSetModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setWeatherSet(weatherSet, handler: handler)
    }
    
}