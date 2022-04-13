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
        manager.filerServers = ["5533"]
//        manager.isScanAllDevice = true
        
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
            let device = XWHDevWatchModel()
            
            device.name = model.name
            
            device.category = bleDevModel?.category ?? .watch
            
            device.type = bleDevModel?.type ?? .skyworthWatchS1
            device.identifier = model.identifier
            device.mac = (model.addressStr ?? (model.advertisementAddress ?? ""))
            device.rssi = model.rssi
            
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
            log.debug("UTE 扫描到的设备: name = \(String(describing: modelDevices.name)), id = \(String(describing: modelDevices.identifier))")
            if modelDevices.name.isEmpty {
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
        }
        
        
        log.info("-----------UTE手表连接状态：----------- \(devicesState.rawValue)")
        
        var stateType = UTEDevStateType.none
        var transferState = XWHDevDataTransferState.failed
        
        switch devicesState {
        // MARK: - 连接
        case .connected:
            if isReconnect {
                connectBindState = .paired
            } else {
                connectBindState = .connected
            }
            
            stateType = .connect
            
        case .disconnected:
            bindTimerInvalidate()
            bindHandler = nil
            
            connectBindState = .disconnected
            
            stateType = .connect
            
        case .connectingError:
            connectBindState = .disconnected
            
            stateType = .connect
            
            
            // MARK: - 固件升级
            // UTE 服务器管理的固件
        case .updateHaveNewVersion:
            stateType = .firmware
            transferState = .inTransit
            
            // UTE 服务器管理的固件
        case .updateNoNewVersion:
            stateType = .firmware
            transferState = .succeed
            
        case .updateBegin:
            stateType = .firmware
            transferState = .inTransit
            
        case .updateSuccess:
            stateType = .firmware
            transferState = .succeed
            
        case .updateError:
            stateType = .firmware
            transferState = .failed
            
            
        default:
            break
        }
        
        switch stateType {
        case .none:
            break
            
        case .connect:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if self.connectBindState == .connected, self.connectBindState == .paired {
                    self.connectHandler?(.success(self.connectBindState))
                    self.cmdHandler?.config(nil, nil, handler: nil)
                } else {
                    self.connectHandler?(.failure(.normal))
                }
                
                self.connectTimerInvalidate()
                self.connectHandler = nil
                self.bleDevModel = nil
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
        }
    }
    
//    func uteManagerBluetoothState(_ bluetoothState: UTEBluetoothState) {
//        log.info("bluetoothState = \(bluetoothState.rawValue)")
//    }
    
    // 蓝牙配对弹框选择回调
    func uteManagerExtraIsAble(_ isAble: Bool) {
        if isAble {
            log.info("UTE 配对 对话框----OK 点击")
//            connectBindState = .paired
//            bindHandler?(.success(connectBindState))
        } else {
            log.info("UTE 配对 对话框----Cancel 点击")
//            bindHandler?(.failure(XWHBLEError.normal))
        }
        
//        bindHandler = nil
    }
    
    // 共享通知
    func uteManagerANCSAuthorization(_ ancsAuthorized: Bool) {
        if ancsAuthorized {
            log.info("UTE 收到系统 共享ANCS通知 --------打开")
        } else {
            log.info("UTE 收到系统 共享ANCS通知 --------关闭")
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
