//
//  XWHBLEDispatchBaseHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import UIKit

class XWHBLEDispatchBaseHandler: NSObject, XWHScanDeviceProtocol, XWHDeviceConnectProtocol, XWHMonitorToDeviceProtocol {
    
    var cmdHandler: XWHDevCmdOperationProtocol?
    
    /// 数据处理handler
    var dataHandler: XWHDevDataOperationProtocol?
    
    var bleDevModel: XWHDevWatchModel?
//    var connectDevModel: XWHDevWatchModel?
    
    // MARK: - 基类计时器等
    ///扫描计时器
    fileprivate var _scanTimer: Timer?
    
    /// 连接计时器
    var connectTimer: Timer?
        
    /// 连接设备超时时间
    var connectTimeoutTime: TimeInterval {
        return 30
    }
    
    // MARK: - 扫描 XWHScanDeviceProtocol
    /// 扫描超时时间
    var scanTimeout: TimeInterval {
        return 3
    }
    
    var scanType: XWHScanDeviceType = .search
    
    weak var scanResultDelegate: XWHScanDeviceResultProtocol?
    
    func startScanDevice(device: XWHDevWatchModel, scanType: XWHScanDeviceType, randomCode: String, resultDelegate: XWHScanDeviceResultProtocol?) {
        bleDevModel = device
        self.scanType = scanType
        scanResultDelegate = resultDelegate
        
        //此处子类调用，可以回调，sdkDeviceToHBDevice子类分别调用的，无须担心
        log.debug("扫描创建计时器")

        scanTimerInvalidate()
        _scanTimer = Timer.scheduledTimer(withTimeInterval: scanTimeout, repeats: false, block: { [weak self] cTimer in
            guard let self = self else {
                return
            }
            
            log.debug("扫描计时器\(self.scanTimeout)s，刷新回调")
            
            let devices = self.sdkDeviceToXWHDevice()
            
            DispatchQueue.main.async {
                self.scanResultDelegate?.deviceDidScanned(devices: devices)
                self.stopScanDevice(resultDelegate: self.scanResultDelegate)
            }
        })
    }
    
    func stopScanDevice(resultDelegate: XWHScanDeviceResultProtocol?) {
        log.debug("扫描停止，计时器销毁")
        scanTimerInvalidate()
        scanResultDelegate = nil
    }
    
    // ----------------------------------------
    
    // MARK: - 监听 XWHMonitorToDeviceProtocol
    weak var monitorDelegate: XWHMonitorFromDeviceProtocol?
    func addMonitorDelegate(_ monitorDelegate: XWHMonitorFromDeviceProtocol) {
        self.monitorDelegate = monitorDelegate
    }
    
    func removeMonitorDelegate(_ monitorDelegate: XWHMonitorFromDeviceProtocol) {
        self.monitorDelegate = nil
    }
    
    // ----------------------------------------
    
    // MARK: - 连接 XWHDeviceConnectProtocol
    /// 连接状态
    var connectBindState: XWHDeviceConnectBindState = .disconnected
    
    /// 连接
    func connect(device: XWHDevWatchModel) {
        connectTimerInvalidate()
        bleDevModel = device
        
        connectTimer = Timer.scheduledTimer(timeInterval: connectTimeoutTime, target: self, selector: #selector(connectTimeout), userInfo: nil, repeats: false)

        RunLoop.current.add(connectTimer!, forMode: .common)
    }
    
    /// 断开连接
    func disconnect(device: XWHDevWatchModel) {
        
    }
    
    // ----------------------------------------
    
    /// 连接超时
    /// - 连接超时处理
    @objc func connectTimeout() {
        if self.connectBindState == .connected {
            bleDevModel = nil

            return
        }

        log.error("-----------连接手表超时-----------")
        connectBindState = .disconnected

        monitorDelegate?.receiveConnectInfo(device: bleDevModel!, connectState: connectBindState, error: .normal)
        bleDevModel = nil
    }

    
    // MARK: - -------- 模型转换 --------
    /// SDK设备模型转XWH设备模型
    func sdkDeviceToXWHDevice() -> [XWHDevWatchModel] {
        return []
    }
    
    // MARK: - Private
    private func scanTimerInvalidate() {
        _scanTimer?.invalidate()
        _scanTimer = nil
    }
    
    // 关闭连接的计时器
    func connectTimerInvalidate() {
        connectTimer?.invalidate()
        connectTimer = nil
    }
    
}
