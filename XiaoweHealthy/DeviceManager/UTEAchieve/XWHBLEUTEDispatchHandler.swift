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
//        manager.filerRSSI = -60
        
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
    override func startScan(device: XWHDevWatchModel, pairMode: XWHDevicePairMode, randomCode: String, progressHandler: XWHDevScanProgressHandler? = nil, scanHandler: XWHDevScanHandler?) {
        super.startScan(device: device, pairMode: pairMode, randomCode: randomCode, progressHandler: progressHandler, scanHandler: scanHandler)
        
//        uteDevices = []

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
            self.manager.startScanDevices()
        }
    }
    
    override func stopScan() {
        super.stopScan()
        manager.stopScanDevices()
        
//        log.debug(manager.delegate)
    }
    
    override func connect(device: XWHDevWatchModel, isReconnect: Bool, connectHandler: XWHDevConnectHandler?) {
        super.connect(device: device, isReconnect: isReconnect, connectHandler: connectHandler)
        
        connectBindState = .connecting
        log.info("-----------UTE开始连接手表-----------")
    
        let uteModel = UTEModelDevices()
        uteModel.identifier = device.identifier
        uteModel.addressStr = device.mac
        
        manager.connect(uteModel)
    }
    
    override func disconnect(device: XWHDevWatchModel?) {
        log.info("-----------UTE断开连接手表-----------")
        
        connectTimerInvalidate()
        bindTimerInvalidate()
        
        connectHandler = nil
        bindHandler = nil
        
        let devModel = UTEModelDevices()
        devModel.identifier = device?.identifier
        manager.disConnect(devModel)
        
        connectBindState = .disconnected
    }
    
    /// 重连设备
    override func reconnect(device: XWHDevWatchModel, connectHandler: XWHDevConnectHandler?) {
        if connectBindState != .disconnected {
            return
        }
        
        log.info("UTE 重连设备")
        
        disconnect(device: device)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.connect(device: device, isReconnect: true, connectHandler: connectHandler)
        }
    }
    
    override func bind(device: XWHDevWatchModel?, bindHandler: XWHDevBindHandler?) {
        bindTimerInvalidate()
        
//        self.bindHandler = nil
//        self.bindHandler = bindHandler
        
//        connectBindState = .pairing
        connectBindState = .paired
        bindHandler?(.success(connectBindState))
//        self.bindHandler = nil
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
        
        
        log.info("-----------UTE手表连接状态：----------- \(devicesState.rawValue)")
        
        // 之前的连接状态
        let preConnBindState = connectBindState
        
        // ute 状态的类型
        var uteStateType = UTEDevStateType.none
        var transferState = XWHDevDataTransferState.failed
        
        var cConnBindState = connectBindState
        switch devicesState {
        // MARK: - 连接
        case .connected:
            log.info("-----------UTE手表连接状态：----------- connected")

            if isReconnect {
                cConnBindState = .paired
            } else {
                cConnBindState = .connected
            }
            
            uteStateType = .connect
                        
        case .disconnected:
            log.info("-----------UTE手表连接状态：----------- disconnected")

            bindTimerInvalidate()
            bindHandler = nil
            
            cConnBindState = .disconnected
            
            uteStateType = .connect
            
        case .connectingError:
            log.info("-----------UTE手表连接状态：----------- connectingError")

            cConnBindState = .disconnected
            
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
            break
            
        case .syncSuccess:
            uteDataHandler?.handleRawData(info, uteSyncState: devicesState)
            
        case .syncError:
            uteDataHandler?.handleError(error)
            
        case .heartDetectingError:
            uteDataHandler?.handleError(error)
            
        case .bloodOxygenDetectingError:
            uteDataHandler?.handleError(error)
            
        case .mpfDetectingFail:
            uteDataHandler?.handleError(error)
            
        // MARK: - ---------
        default:
            break
        }
        
        switch uteStateType {
        case .none:
            break
            
        case .connect:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                
                if cConnBindState == .connected || cConnBindState == .paired {
                    self.cmdHandler?.config(nil, nil, handler: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 13) {
                        self.connectBindState = cConnBindState
                        self.connectHandler?(.success(self.connectBindState))
                        
                        self.connectTimerInvalidate()
                        self.connectHandler = nil
                        self.bleDevModel = nil
                        
                        var deviceModel: XWHDevWatchModel!
                        if let cUteModel = self.manager.connectedDevicesModel {
                            deviceModel = self.getDeviceInfo(with: cUteModel)
                        } else {
                            deviceModel = XWHDevWatchModel()
                            deviceModel.category = .watch
                            deviceModel.type = .skyworthWatchS1
                        }
                        
                        self.monitorHnadler?(deviceModel, self.connectBindState)
                        
//                        if (preConnBindState == .connected || preConnBindState == .paired) && self.connectHandler == nil {
//
//                        }
                    }
                } else {
                    self.connectBindState = cConnBindState
                    self.connectHandler?(.failure(.normal))
                    
                    self.connectTimerInvalidate()
                    self.connectHandler = nil
                    self.bleDevModel = nil
                    
                    if (preConnBindState == .connected || preConnBindState == .paired) && self.connectHandler == nil {
                        var deviceModel: XWHDevWatchModel!
                        if let cUteModel = self.manager.connectedDevicesModel {
                            deviceModel = self.getDeviceInfo(with: cUteModel)
                        } else {
                            deviceModel = XWHDevWatchModel()
                            deviceModel.category = .watch
                            deviceModel.type = .skyworthWatchS1
                        }
                        
                        self.monitorHnadler?(deviceModel, self.connectBindState)
                    }
                }
            }
            
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
    
//    func uteManagerBluetoothState(_ bluetoothState: UTEBluetoothState) {
//        log.info("bluetoothState = \(bluetoothState.rawValue)")
//    }
    
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
    
}
