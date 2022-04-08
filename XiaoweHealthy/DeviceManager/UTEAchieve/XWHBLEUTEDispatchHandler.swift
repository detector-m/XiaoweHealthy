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
//        manager.filerServers = ["5533"]
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
        
//        manager.startScanDevices()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
            self.manager.startScanDevices()
        }
    }
    
    override func stopScan() {
        super.stopScan()
        manager.stopScanDevices()
    }
    
    override func sdkDeviceToXWHDevice() -> [XWHDevWatchModel] {
        let devices = uteDevices.map { (model) -> XWHDevWatchModel in
            let device = XWHDevWatchModel()
            
//            device.uuid = model.uuidString
            
            device.name = model.name
            device.type = .skyworthWatchS1
            device.identifier = model.identifier
            device.mac = model.addressStr
            device.rssi = model.rssi
            
            return device
        }
        
        uteDevices = []
        
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
            uteDevices.append(modelDevices)
        }
    }
    
    func uteManagerExtraIsAble(_ isAble: Bool) {
        if isAble {
            log.debug("***Successfully turn on the additional functions of the device")
        }else{
            log.debug("***Failed to open the extra functions of the device, the device is actively disconnected, please reconnect the device")
        }
    }
    
    // 连接设备成功回调
    func uteManagerDevicesSate(_ devicesState: UTEDevicesSate, error: Error!, userInfo info: [AnyHashable : Any]! = [:]) {
        
    }
    
}
