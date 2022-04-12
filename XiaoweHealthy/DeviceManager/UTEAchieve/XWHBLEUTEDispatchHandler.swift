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
    override func startScan(pairMode: XWHDevicePairMode, randomCode: String, progressHandler: XWHDevScanProgressHandler? = nil, scanHandler: XWHDevScanHandler?) {
        super.startScan(pairMode: pairMode, randomCode: randomCode, progressHandler: progressHandler, scanHandler: scanHandler)
        
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
        
        log.info("-----------UTE开始连接手表-----------")
    
        let uteModel = UTEModelDevices()
        uteModel.identifier = device.identifier
        uteModel.addressStr = device.mac
        
        manager.connect(uteModel)
    }
    
    override func disconnect(device: XWHDevWatchModel?) {
        log.info("-----------UTE断开连接手表-----------")
        
        let devModel = UTEModelDevices()
        devModel.identifier = device?.identifier
        manager.disConnect(devModel)
    }
    
    override func sdkDeviceToXWHDevice() -> [XWHDevWatchModel] {
        let devices = uteDevices.map { (model) -> XWHDevWatchModel in
            let device = XWHDevWatchModel()
            
//            device.uuid = model.uuidString
            
            device.name = model.name
//            device.type = .skyworthWatchS1
            device.type = connectDevModel?.type ?? .skyworthWatchS1
            device.identifier = model.identifier
            device.mac = (model.addressStr ?? (model.advertisementAddress ?? ""))
            device.rssi = model.rssi
            
            return device
        }
        
        uteDevices = []
        connectDevModel = nil
        
        return devices
    }

}


extension XWHBLEUTEDispatchHandler: UTEManagerDelegate {
    
    // 发现设备回调
    func uteManagerDiscover(_ modelDevices: UTEModelDevices!) {
        log.debug(modelDevices)
        
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
            log.debug("***Scanned device name=\(String(describing: modelDevices.name)) id=\(String(describing: modelDevices.identifier))")
            if modelDevices.name.isEmpty {
                return
            }
            
            uteDevices.append(modelDevices)
        }
    }
    
    // 连接设备成功回调
    func uteManagerDevicesSate(_ devicesState: UTEDevicesSate, error: Error!, userInfo info: [AnyHashable : Any]! = [:]) {
        log.info("-----------UTE手表连接状态：----------- \(devicesState.rawValue)")
        switch devicesState {
        case .connected:
            connectState = .connected
            
        case .disconnected:
            connectState = .disconnected
            
        default:
            connectState = .disconnected
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            if self.connectState == .connected {
                self.connectHandler?(.success(self.connectState), self.connectState)
                self.cmdHandler?.config(nil, nil, handler: nil)
            } else {
                self.connectHandler?(.failure(.normal), self.connectState)
            }
            
            self.connectHandler = nil
        }
    }
    
    //
    func uteManagerBluetoothState(_ bluetoothState: UTEBluetoothState) {
        log.info("bluetoothState = \(bluetoothState.rawValue)")
    }
    
    // 蓝牙配对弹框选择回调
    func uteManagerExtraIsAble(_ isAble: Bool) {
        if isAble {
            log.info("UTE 配对 对话框----OK 点击")
        } else{
            log.info("UTE 配对 对话框----Cancel 点击")
        }
    }
    
    // 打开或关闭消息推送，回调代理方法
    func uteManageUTEOptionCallBack(_ callback: UTECallBack) {

    }
}
