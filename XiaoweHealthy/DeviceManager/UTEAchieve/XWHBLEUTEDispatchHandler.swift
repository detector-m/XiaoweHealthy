//
//  XWHBLEUTEDispatchHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import UIKit
import UTESmartBandApi

class XWHBLEUTEDispatchHandler: XWHBLEDispatchBaseHandler {
    
    // MARK: - 变量
    override var scanTimeout: TimeInterval {
        return 3
    }
    
    override var connectTimeoutTime: TimeInterval {
        return 45
    }
    
    var manager: UTESmartBandClient {
        return UTESmartBandClient.sharedInstance()
    }
    
    var uteDevices: [UTEModelDevices] = []
    
    var uteDataHandler: XWHUTEDataOperationHandler? {
        guard let cHandler = dataHandler as? XWHUTEDataOperationHandler else {
            return nil
        }
        
        return cHandler
    }
    
    private weak var sportHandlerDelegate: XWHDataFromDeviceInteractionProtocol?
    
    override init() {
        super.init()
        
        // SDK初始化
        manager.initUTESmartBandClient()
        
        // 日志
        manager.debugUTELog = true
//        manager.logType = .print
        
        // 重复扫描设备(这样设备信号值才会实时变化)
        manager.isScanRepeat = true
        
        // 设置信号值过滤
        manager.filerRSSI = -70
        
        // 设置过滤服务（可以搜索包含设置服务的设备）
        // 默认情况下，SDK只会扫描其中某个设备，请开发者再次设置过滤
//        manager.filerServers = ["5533"]
        manager.isScanAllDevice = true
        
        manager.delegate = self
        
        if manager.isHasUserID {
            log.error("有用户ID")
        }
        
//        UTEManagerDelegate
        
        log.info("UTE SDK Version = \(manager.sdkVersion())")
    }
    
    // 开始扫描
    override func startScanDevice(device: XWHDevWatchModel, scanType: XWHScanDeviceType, randomCode: String, resultDelegate: XWHScanDeviceResultProtocol?) {
        super.startScanDevice(device: device, scanType: scanType, randomCode: randomCode, resultDelegate: resultDelegate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.manager.startScanDevices()
        }
    }
    
    override func stopScanDevice(resultDelegate: XWHScanDeviceResultProtocol?) {
        manager.stopScanDevices()
        super.stopScanDevice(resultDelegate: resultDelegate)
    }
    
    // ----------------------------------------
    
    override func connect(device: XWHDevWatchModel) {
        if manager.bluetoothState == .close {
            log.error("蓝牙关闭")
            connectBindState = .disconnected
            handleMonitor(connectBindState: connectBindState, error: .bleClose)
            return
        }
        
        super.connect(device: device)
        
        connectBindState = .connecting
        log.info("-----------UTE开始连接手表-----------")
        
        handleMonitor(connectBindState: connectBindState, error: nil)
    
        let uteModel = UTEModelDevices()
        uteModel.identifier = device.identifier
        uteModel.addressStr = device.mac
        
        manager.connect(uteModel)
    }
    
    override func disconnect(device: XWHDevWatchModel) {
        log.info("-----------UTE断开连接手表-----------")
        
        connectTimerInvalidate()
        
        let devModel = UTEModelDevices()
        devModel.identifier = device.identifier
        manager.disConnect(devModel)
        
        connectBindState = .disconnected
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.handleMonitor(connectBindState: self.connectBindState, error: nil)
        }
    }
    
    override func sdkDeviceToXWHDevice() -> [XWHDevWatchModel] {
        let devices = uteDevices.map { (model) -> XWHDevWatchModel in
            let device = getDeviceInfo(with: model)
            return device
        }
        
        uteDevices = []
        bleDevModel = nil
        
        return devices
    }

}


// MARK: - UTEManagerDelegate
extension XWHBLEUTEDispatchHandler: UTEManagerDelegate {
    
    // 发现设备回调
    func uteManagerDiscover(_ modelDevices: UTEModelDevices!) {
        var sameDevices = false
        for model in uteDevices {
            if (model.identifier?.isEqual(modelDevices.identifier as String))! {
                model.rssi = modelDevices.rssi
                model.name = modelDevices.name
                sameDevices = true
                break
            }
        }
        
        if !sameDevices {
            log.debug("UTE 扫描到的设备: name = \(String(describing: modelDevices.name)), id = \(String(describing: modelDevices.identifier)), rssi = \(modelDevices.rssi)")
            
            guard let name = modelDevices.name, !name.isEmpty else {
                return
            }
            
            guard let cId = modelDevices.identifier, !cId.isEmpty else {
                return
            }
            
            uteDevices.append(modelDevices)
        }
    }
    
    // 连接设备成功回调
    func uteManagerDevicesSate(_ devicesState: UTEDevicesSate, error: Error?, userInfo info: [AnyHashable: Any]? = [:]) {
        // UTE 设备状态类型
        enum UTEDevStateType {
            case none
            case connect
            case firmware
            
            case syncData
        }
        
        // ute 状态的类型
        var uteStateType = UTEDevStateType.none
        var transferState = XWHDevDataTransferState.failed
        
        switch devicesState {
        // MARK: - 连接
        case .connected:
            log.info("-- UTE手表连接状态(\(devicesState.rawValue))：-- connected")
            uteStateType = .connect
                        
        case .disconnected:
            log.info("-- UTE手表连接状态(\(devicesState.rawValue))：-- disconnected")
            uteStateType = .connect
            
        case .connectingError:
            log.info("-- UTE手表连接状态(\(devicesState.rawValue))：-- connectingError")
            uteStateType = .connect
            
            
            // MARK: - 固件升级
            // UTE 服务器管理的固件
        case .updateHaveNewVersion:
            uteStateType = .firmware
            transferState = .inTransit
            
            // UTE 服务器管理的固件
        case .updateNoNewVersion:
            uteStateType = .firmware
            transferState = .succeed
            
        case .updateBegin:
            uteStateType = .firmware
            transferState = .inTransit
            
        case .updateSuccess:
            uteStateType = .firmware
            transferState = .succeed
            
        case .updateError:
            uteStateType = .firmware
            transferState = .failed
            
        // MARK: - SyncData
        case .syncBegin:
            log.info("-- UTE手表连接状态(\(devicesState.rawValue))：-- syncBegin")
            break
            
        case .syncSuccess:
            log.info("-- UTE手表连接状态(\(devicesState.rawValue))：-- syncSuccess")
            uteDataHandler?.handleRawData(info, uteSyncState: devicesState)
            
        case .syncError:
            log.info("-- UTE手表连接状态(\(devicesState.rawValue))：-- syncError")
            uteDataHandler?.handleError(error)
            
        case .heartDetectingError:
            uteDataHandler?.handleError(error)
            
        case .bloodOxygenDetectingError:
            uteDataHandler?.handleError(error)
            
        case .mpfDetectingFail:
            uteDataHandler?.handleError(error)
            
        // MARK: -
        default:
            break
        }
        
        switch uteStateType {
        case .none:
            break
            
        case .connect:
            handleUTEConnect(devicesState, error: error)
            
        case .firmware:
            guard let uteCmdHandler = cmdHandler as? XWHUTECmdOperationHandler else {
                log.error("UTE cmdHandler 无法转换为 XWHUTECmdOperationHandler")
                
                return
            }
            
            if transferState == .failed {
                var tError = XWHError()
                tError.message = error?.localizedDescription ?? "UTE 数据传输失败"
                uteCmdHandler.handleTransferResult(.failure(tError))
            } else {
                uteCmdHandler.handleTransferResult(.success(transferState))
            }
            
        case .syncData:
            break
        }
    }
    
    func uteManagerBluetoothState(_ bluetoothState: UTEBluetoothState) {
        if bluetoothState == .close {
            connectTimerInvalidate()
            
            connectBindState = .disconnected
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.handleMonitor(connectBindState: self.connectBindState, error: .bleClose)
            }
        }
    }
    
    // 蓝牙配对弹框选择回调
    func uteManagerExtraIsAble(_ isAble: Bool) {
        if isAble {
            log.debug("UTE 配对 对话框----OK 点击")
//            connectBindState = .paired
//            bindHandler?(.success(connectBindState))
        } else {
            log.error("UTE 配对 对话框----Cancel 点击")
//            bindHandler?(.failure(XWHBLEError.normal))
        }
        
//        bindHandler = nil
    }
    
    // 共享通知
    func uteManagerANCSAuthorization(_ ancsAuthorized: Bool) {
        if ancsAuthorized {
            log.debug("UTE 收到系统 共享ANCS通知 --------打开")
        } else {
            log.error("UTE 收到系统 共享ANCS通知 --------关闭")
        }
    }
    
    // 打开或关闭消息推送，回调代理方法
    func uteManageUTEOptionCallBack(_ callback: UTECallBack) {

    }
    
    // MARK: - 固件升级（Firmware）
    /// 升级进度代理监听
    func uteManagerUpdateProcess(_ process: Int) {
        guard let uteCmdHandler = cmdHandler as? XWHUTECmdOperationHandler else {
            log.error("UTE cmdHandler 无法转换为 XWHUTECmdOperationHandler")
            return
        }
        
        uteCmdHandler.handleTransferProgress(process)
    }
    
}

// MARK: - 处理连接
extension XWHBLEUTEDispatchHandler {
    
    private func handleUTEConnect(_ devicesState: UTEDevicesSate, error: Error?) {
        connectTimerInvalidate()
        bleDevModel = nil
        
        if devicesState == .connectingError {
            connectBindState = .disconnected
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.handleMonitor(connectBindState: self.connectBindState, error: .normal)
            }
            
            return
        }
        
        if devicesState == .disconnected {
            connectBindState = .disconnected
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.handleMonitor(connectBindState: self.connectBindState, error: nil)
            }
            
            return
        }
        
        cmdHandler?.config(nil, nil, handler: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 14) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.connectBindState = .connected
            
            self.handleMonitor(connectBindState: self.connectBindState, error: nil)
        }
    }
    
}

// MARK: - UTEManagerDelegate(Sport)
extension XWHBLEUTEDispatchHandler {
    
    /// 运动模式回调
    func uteManagerReceiveSportMode(_ info: UTEDeviceSportModeInfo!) {
//        UTEDeviceSportMode
//        UTEDeviceSportModeStatus
//        UTEDeviceIntervalTime
        log.debug("UTE 运动数据 SportModeInfo Mode = \(info.status.rawValue)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            self.sportHandlerDelegate?.receiveSportState(self.getSportState(uteSportModel: info))
        }
        
    }
    
    func uteManagerReceiveTodaySport(_ dict: [AnyHashable : Any]!) {
        log.debug("UTE 运动数据 TodaySport = \(String(describing: dict))")
    }
    
    func uteManagerReceiveSportHRM(_ dict: [AnyHashable : Any]!) {
//        kUTEQuerySportHRMData
//        log.debug("UTE 运动数据 SportHRM = \(dict)")
        
        guard let uteSportModel = dict["kUTEQuerySportHRMData"] as? UTEModelSportHRMData else {
            return
        }
        
//        guard let uteHRArray = uteSportModel.hrmArray as? [NSNumber] else {
//            return
//        }
        
//        let hrModels: [XWHHeartModel] = uteHRArray.compactMap({ (h: String) in
//            let hValue = h.int ?? 0
//            if hValue <= 0 {
//                return nil
//            }
//
//            let hrModel = XWHHeartModel()
//            hrModel.value = hValue
//            return hrModel
//        })
        
        let hrModel = XWHHeartModel()
        hrModel.value = uteSportModel.hrmCurrent
        self.sportHandlerDelegate?.receiveSportHeartRate([hrModel])
    }
    
}

// MARK: - 数据交互
extension XWHBLEUTEDispatchHandler: XWHDataToDeviceInteractionProtocol {
    
    func addSportHandlerDelegate(_ fromDelegate: XWHDataFromDeviceInteractionProtocol) {
        sportHandlerDelegate = fromDelegate
    }
    
    func removeSportHandlerDelegate() {
        sportHandlerDelegate = nil
    }
    
    func sendSportState(sportModel: XWHSportModel) {
        setUTESportState(sportModel: sportModel)
    }
    
    func sendSportInfo(_ sportInfo: XWHSportModel) {
        sendUTESportInfo(sportModel: sportInfo)
    }
    
    private func setUTESportState(sportModel: XWHSportModel) {
        let uteSportType: UTEDeviceSportMode = getUteSportType(sportModel: sportModel)
        var isOpen = false
        
        if sportModel.state == .continue {
            let uteSportModel = getUteSportInfo(sportModel: sportModel)
            manager.setUTESportModelContinue(uteSportModel)
            
            return
        }
        
        if sportModel.state == .pause {
            let uteSportModel = getUteSportInfo(sportModel: sportModel)
            manager.setUTESportModelPause(uteSportModel)
            
            return
        }
        
        if sportModel.state == .start {
            isOpen = true
        } else if sportModel.state == .stop {
            isOpen = false
        }

        manager.setUTESportModel(uteSportType, open: isOpen, hrmTime: UTEDeviceIntervalTime.time10s) { (mode, cOpen) in
            
        }
    }
    
    private func getUteSportInfo(sportModel: XWHSportModel) -> UTEDeviceSportModeInfo {
        let model = UTEDeviceSportModeInfo.init()
        
        model.mode = getUteSportType(sportModel: sportModel)
        model.status = getUteSportState(sportModel: sportModel)
        
        //CN:其他值，把app的数据赋值发下去给设备
        //EN:Other values, assign app data to the device
        
        model.calories = sportModel.cal
        model.distance = sportModel.distance
        model.duration = sportModel.duration
        model.speed = sportModel.pace
        model.hrmTime = UTEDeviceIntervalTime.time10s
        
        return model
    }
    
    private func getUteSportType(sportModel: XWHSportModel) -> UTEDeviceSportMode {
        switch sportModel.type {
        case .run:
            return .running
            
        case .walk:
            return .outdoorWalking
            
        case .ride:
            return .cycling
            
        case .climb:
            return .mountaineering
            
        default:
            return .none
        }
    }
    
    private func getUteSportState(sportModel: XWHSportModel) -> UTEDeviceSportModeStatus {
        switch sportModel.state {
        case .start:
            return .open
            
        case .stop:
            return .close
            
        case .pause:
            return .pause
            
        case .continue:
            return .continue
        }
    }
    
    private func getSportState(uteSportModel: UTEDeviceSportModeInfo) -> XWHSportState {
//         UTEDeviceSportModeStatus
        switch uteSportModel.status {
        case .close:
            return .stop
            
        case .open:
            return .start
            
        case .pause:
            return .pause
            
        case .continue:
            return .continue
            
        @unknown default:
            return .stop
        }
    }
    
    private func sendUTESportInfo(sportModel: XWHSportModel) {
        let uteSportModel = getUteSportInfo(sportModel: sportModel)
        manager.setUTESportModelInfo(uteSportModel)
    }
    
}

// MARK: - Private
extension XWHBLEUTEDispatchHandler {
    
    private func getDeviceInfo(with uteDevice: UTEModelDevices) -> XWHDevWatchModel {
        let device = XWHDevWatchModel()

        let devId = uteDevice.identifier ?? ""
//        device.identifier = XWHDeviceHelper.getStandardDeviceSn(devId)
        device.identifier = devId
        
        let devMac = (uteDevice.addressStr ?? (uteDevice.advertisementAddress ?? ""))
        device.mac = XWHDeviceHelper.getStandardFormatMac(devMac)
        
        device.name = uteDevice.name
        device.brand = "SKYWORTH"
        
        device.category = .watch
        device.type = bleDevModel?.type ?? .skyworthWatchS1
        
        device.rssi = uteDevice.rssi
        
        return device
    }
    
    /// 处理监测结果
    private func handleMonitor(connectBindState: XWHDeviceConnectBindState, error: XWHBLEError?) {
        let deviceModel = getMonitorDeviceModel()
        monitorDelegate?.receiveConnectInfo(device: deviceModel, connectState: connectBindState, error: error)
    }
    
    private func getMonitorDeviceModel() -> XWHDevWatchModel {
        var deviceModel: XWHDevWatchModel
        if let cUteModel = self.manager.connectedDevicesModel {
            deviceModel = self.getDeviceInfo(with: cUteModel)
        } else {
            deviceModel = XWHDevWatchModel()
            deviceModel.category = .watch
            deviceModel.type = .skyworthWatchS1
        }
        
        return deviceModel
    }
    
}

// MARK: - UTEBluetoothState extension
extension UTEBluetoothState {
    
    var name: String {
        switch self {
        case .open:
            return "打开"
            
        case .close:
            return "关闭"
            
        case .resetting:
            return "重置"
            
        case .unsupported:
            return "不支持"
            
        case .unauthorized:
            return "未授权"
            
        case .unknown:
            return "未知"
            
        @unknown default:
            return "未知的默认状态"
        }
    }
    
}
