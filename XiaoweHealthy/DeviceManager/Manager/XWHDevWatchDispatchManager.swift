//
//  XWHDevWatchDispatchManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation
import UIKit
import CoreBluetooth


var XWHDDMShared: XWHDevWatchDispatchManager {
    XWHDevWatchDispatchManager.shared
}

/// 此类为XWHDevice 蓝牙相关操作分发中心 - 继承 外设管理 - 外设设置 - 数据接收与发送相关，并分发给不同厂商SDK处理事物
class XWHDevWatchDispatchManager {
    
    // 单例初始化
    private static var _shared = XWHDevWatchDispatchManager.init()
    static var shared: XWHDevWatchDispatchManager {
        return _shared
    }
    
    // 蓝牙状态监听
    var bleStateHandler: BluetoothStateHandler.BLEStateHandler? {
        didSet {
            BluetoothStateHandler.shared.reqeustState(bleStateHandler)
        }
    }
    
    // 核心设备与外设操作
    private var bleHandler: XWHBLEDispatchBaseHandler?
    
    // 设备指令操作
    private var cmdHandler: XWHDevCmdOperationProtocol?
    
    // 天气服务数据处理
    internal var wsHandler: XWHWeatherServiceProtocol?
    
    // 数据处理
    private var dataHandler: XWHDevDataOperationProtocol?
    
    // 状态监听
    private var monitorHandler: XWHDeviceMonitorHandler?
    
    // 交互数据handler
    private var interactionDataHandler: XWHDataToDeviceInteractionProtocol?
    
    private var monitors: [XWHMonitorFromDeviceProtocol] = []

    
    // MARK: - handlers
    /* 简单粗暴，为了减少设备init导致delegate变化 */
    private lazy var _uteBLEHandler = XWHBLEUTEDispatchHandler()
    private lazy var _uteCmdHandler = XWHUTECmdOperationHandler()
    private lazy var _uteWSHandler = XWHUTEWeatherInfoHandler()
    private lazy var _uteDataHandler = XWHUTEDataOperationHandler()
    
    private init() {
//        BluetoothStateHandler.shared.reqeustState { [weak self] state in
//            log.info("蓝牙状态 state = \(state.string)")
//            if state.isOpen {
//                guard let connectBindState = self?.bleHandler?.connectBindState, connectBindState == .disconnected else {
//                    return
//                }
//                
//                guard let devModel = XWHDeviceDataManager.getCurrentDevice() else {
//                    return
//                }
//                
//                self?.reconnect(device: devModel, connectHandler: nil)
//            }
//        }
    }

    
    // MARK: - 方法
    /// 监听蓝牙开关
    func monitorBLEState() {
        BluetoothStateHandler.shared.reqeustState { [weak self] state in
            log.info("蓝牙状态 state = \(state.string)")
            self?.receiveBLEState(state)
        }
    }
    
    func configCurrentDevice() {
        if let cDevice = ddManager.getCurrentDevice() {
            config(device: cDevice)
        } else {
            config(device: XWHDevWatchModel())
        }
    }
    
    @discardableResult
    func config(device: XWHDevWatchModel) -> Self {
        reset()
        
        switch device.type {
        case .none:
            break
            
        case .skyworthWatchS1, .skyworthWatchS2:
            bleHandler = _uteBLEHandler
                        
            cmdHandler = _uteCmdHandler
            bleHandler?.cmdHandler = cmdHandler
            
            wsHandler = _uteWSHandler
            cmdHandler?.wsHandler = wsHandler
            
            dataHandler = _uteDataHandler
            bleHandler?.dataHandler = dataHandler
            
            interactionDataHandler = _uteBLEHandler
        }
        
        bleHandler?.addMonitorDelegate(self)
        dataHandler?.addMonitorDelegate(self)
        
        return self
    }
    
    private func reset() {
        bleHandler?.cmdHandler = nil
        bleHandler = nil
        
        cmdHandler?.wsHandler = nil
        cmdHandler = nil
        
        wsHandler = nil
        
        dataHandler = nil
        
        interactionDataHandler = nil
        
        bleHandler?.removeMonitorDelegate(self)
        dataHandler?.removeMonitorDelegate(self)
    }
    
}

// MARK: - 扫描设备 XWHScanDeviceProtocol
extension XWHDevWatchDispatchManager: XWHScanDeviceProtocol {
    
    var scanTimeout: TimeInterval {
        return bleHandler?.scanTimeout ?? 5
    }
    
    var scanType: XWHScanDeviceType {
        bleHandler?.scanType ?? .search
    }
    
    func startScanDevice(device: XWHDevWatchModel, scanType: XWHScanDeviceType, randomCode: String, resultDelegate: XWHScanDeviceResultProtocol?) {
        config(device: device)
        bleHandler?.startScanDevice(device: device, scanType: scanType, randomCode: randomCode, resultDelegate: resultDelegate)
    }
    
    func stopScanDevice(resultDelegate: XWHScanDeviceResultProtocol?) {
        bleHandler?.stopScanDevice(resultDelegate: resultDelegate)
    }
    
}

// MARK: - 监听 XWHMonitorToDeviceProtocol
extension XWHDevWatchDispatchManager: XWHMonitorToDeviceProtocol {
    
    func addMonitorDelegate(_ monitorDelegate: XWHMonitorFromDeviceProtocol) {
        if monitors.contains(where: { $0 === monitorDelegate }) {
            return
        }
        
        monitors.append(monitorDelegate)
    }

    func removeMonitorDelegate(_ monitorDelegate: XWHMonitorFromDeviceProtocol) {
        monitors.removeAll(where: { $0 === monitorDelegate })
    }
    
}

// MARK: - 监听 XWHMonitorFromDeviceProtocol
extension XWHDevWatchDispatchManager: XWHMonitorFromDeviceProtocol {
    
    func receiveBLEState(_ state: CBManagerState) {
        for iDelegate in monitors {
            iDelegate.receiveBLEState(state)
        }
    }
    
    func receiveConnectInfo(device: XWHDevWatchModel, connectState: XWHDeviceConnectBindState, error: XWHBLEError?) {
        for iDelegate in monitors {
            iDelegate.receiveConnectInfo(device: device, connectState: connectState, error: error)
        }
    }
    
    func receiveSyncDataStateInfo(syncState: XWHDevDataTransferState, progress: Int, error: XWHError?) {
        for iDelegate in monitors {
            iDelegate.receiveSyncDataStateInfo(syncState: syncState, progress: progress, error: error)
        }
    }
    
}


// MARK: - 连接 XWHDeviceConnectProtocol
extension XWHDevWatchDispatchManager: XWHDeviceConnectProtocol {
    /// 连接状态
    var connectBindState: XWHDeviceConnectBindState {
        bleHandler?.connectBindState ?? .disconnected
    }

    /// 连接
    func connect(device: XWHDevWatchModel) {
        config(device: device)
        bleHandler?.connect(device: device)
    }

    /// 断开连接
    func disconnect(device: XWHDevWatchModel) {
        bleHandler?.disconnect(device: device)
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
    
    /// 设置精神压力设置
    func setMentalStressSet(_ mentalStressSet: XWHMentalStressSetModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.setMentalStressSet(mentalStressSet, handler: handler)
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
    
    /// 同步天气信息
    func sendWeatherInfo(_ weatherInfo: XWHWeatherInfoModel, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.sendWeatherInfo(weatherInfo, handler: handler)
    }
    
    /// 同步天气服务的天气信息信息
    func sendWeatherServiceWeatherInfo(cityId: String? = nil, latitude: Double, longitude: Double, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.sendWeatherServiceWeatherInfo(cityId: cityId, latitude: latitude, longitude: longitude, handler: handler)
    }

    
    /// 同步联系人
    func sendContact(_ contacts: [XWHDevContactModel], handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.sendContact(contacts, handler: handler)
    }
    
}

// MARK: - 表盘 （Dial）
extension XWHDevWatchDispatchManager {
    
    /// 发送表盘数据
    func sendDialData(_ data: Data, progressHandler: DevTransferProgressHandler?, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.sendDialData(data, progressHandler: progressHandler, handler: handler)
    }
    
    /// 发送表盘文件
    func sendDialFile(_ fileUrl: URL, progressHandler: DevTransferProgressHandler?, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.sendDialFile(fileUrl, progressHandler: progressHandler, handler: handler)
    }
    
}

// MARK: - 固件 （Firmware）
extension XWHDevWatchDispatchManager {
    
    /// 发送固件文件
    func sendFirmwareFile(_ fileUrl: URL, progressHandler: DevTransferProgressHandler?, handler: XWHDevCmdOperationHandler?) {
        cmdHandler?.sendFirmwareFile(fileUrl, progressHandler: progressHandler, handler: handler)
    }
    
}

// MARK: - 天气服务数据 （WeatherService）
extension XWHDevWatchDispatchManager: XWHWeatherServiceProtocol {
    
    /// 获取天气服务的天气数据
    func getWeatherServiceWeatherInfo(cityId: String? = nil, latitude: Double, longitude: Double, handler: XWHWeatherServiceHandler?) {
        wsHandler?.getWeatherServiceWeatherInfo(cityId: cityId, latitude: latitude, longitude: longitude, handler: handler)
    }
    
    
}

// MARK: - 同步数据
extension XWHDevWatchDispatchManager: XWHDevDataOperationProtocol {
    
    var state: XWHDevDataTransferState {
        return dataHandler?.state ?? .failed
    }
    
    func setDataOperation(progressHandler: DevSyncDataProgressHandler?, resultHandler: XWHDevDataOperationHandler?) {
        dataHandler?.setDataOperation(progressHandler: progressHandler, resultHandler: resultHandler)
    }
    
    func resetDataOperation() {
        dataHandler?.resetDataOperation()
    }
    
    func syncData() {
        dataHandler?.syncData()
    }
    
}

// MARK: - 数据交互
extension XWHDevWatchDispatchManager: XWHDataToDeviceInteractionProtocol {
    
    func addSportHandlerDelegate(_ fromDelegate: XWHDataFromDeviceInteractionProtocol) {
        interactionDataHandler?.addSportHandlerDelegate(fromDelegate)
    }
    
    func removeSportHandlerDelegate() {
        interactionDataHandler?.removeSportHandlerDelegate()
    }
    
    func sendSportState(sportModel: XWHSportModel) {
        interactionDataHandler?.sendSportState(sportModel: sportModel)
    }
    
    func sendSportInfo(_ sportInfo: XWHSportModel) {
        interactionDataHandler?.sendSportInfo(sportInfo)
    }
    
}

